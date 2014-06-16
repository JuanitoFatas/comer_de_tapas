require 'http'
require 'json'
require 'pathname'
require 'fileutils'

module ComerDeTapas
  class Client

    # Initialize comer de tapas
    # $ mkdir -p ~/.rubytapas/
    # $ touch ~/.rubytapas/.credentials
    def init!
      if RUBYTAPAS_DIR.exist? && CREDENTIAL_FILE.exist?
        abort 'Credentials found. type `comer_de_tapas download` to download.'
      end
      create_rubytapas_files!
      puts '~/.rubytapas/.credentials folder and file has been created.'
    end

    # Fetch latest feed on rubytapas.dpdcart.com
    # Parse it to episode, save episodes data as json to ~/.rubytapas.json
    def fetch_episodes! force=nil
      return puts 'Use cached episode data.' if fresh? && force.nil?
      puts 'Force fetching. Getting latest Ruby Tapas...' if force
      puts 'Fetching episodes...'
      if get_feed_with_basic_auth
        save_feed_data parse_xml_feed
        puts 'Episodes successfully fetched and saved.'
      end
    end

    # Create user specified folder: credentials[:save_path]
    def prepare_save_folder!
      return puts "#{save_folder} found." if save_folder.exist?

      save_folder.mkpath
      puts "#{save_folder} created."
    end

    # Authenticate and return Cookie
    def authenticate
      @cookie ||= HTTP.post(LOGIN_URL, form_params).headers['Set-Cookie']
    end

    # Load episodes json from EPISODES_JSON_FILE
    def load_episodes
      @episodes ||= JSON.parse(EPISODES_JSON_FILE.read)
    end

    # User spefified folder to save episodes.
    # @return [Pathname]
    def save_folder
      Pathname(credentials[:save_path]).expand_path
    end

    # Download episode in parallel using Actors
    # Powered by Celluloid::IO
    def download_all_tapas!
      episodes.each do |episode|
        FileUtils.cd(save_folder) do
          episode_title = episode['title']
          puts "Downloading Epsiode #{episode_title}..."

          episode_folder = save_folder.join(sanitized episode_title)

          FileUtils.mkdir_p episode_folder unless episode_folder.exist?

          FileUtils.cd episode_folder do
            fetcher = Fetcher.new
            file_and_links = episode['links']
            downloadables = find_downloadables file_and_links, fetcher

            if downloadables.all? &:nil?
              puts 'Already downloaded, skip.'
              next
            end

            download_parallelly! downloadables
            puts "Episode #{episode_title} content all saved."
          end
        end
      end
    end

    private

      attr_reader :feed_xml, :cookie, :episodes

      # Download episode all attachments
      # compact to remove attachment that already downloaded
      # @param [Array] downloadables
      def download_parallelly! downloadables
        downloadables.compact.each do |file, future|
          puts "Downloading #{file}..."
          response = future.value.to_s
          IO.write file, response
          puts "#{file} saved."
        end
      end

      # Find episode's attachment that has not been downloaded
      # @param [Array] file_and_links
      def find_downloadables file_and_links, fetcher
        file_and_links.map do |file_and_link|
          file_name = file_and_link['filename']

          # mp4 less than 3MB considered as unfinished. Redownload it.
          FileUtils.rm file_name if small_mp4? file_name

          next if File.exist? file_name

          q, v = file_and_link['link'].split('?').last.split('=')
          [file_name, fetcher.future.fetch(DOWNLOAD_URL, cookie, { q => v })]
        end
      end

      # Return true if file is a mp4 and its size less than 3MB.
      def small_mp4?(file)
        return false unless File.exist? file
        File.size(file) < 3*1024*1024 && File.extname(file) == '.mp4'
      end

      # mkdir -p ~/.rubytapas
      # touch ~/.rubytapas/.credentials
      def create_rubytapas_files!
        RUBYTAPAS_DIR.mkpath
        FileUtils.touch CREDENTIAL_FILE
        CREDENTIAL_FILE.write credential_template
      end

      # Use to create empty credential file
      def credential_template
        require 'yaml'
        {"credentials"=>[{"email"=>nil}, {"password"=>nil}, {"save_path"=>nil}]}.to_yaml
      end

      # Get raw feed data (XML), RSS
      def get_feed_with_basic_auth
        puts 'Authorizing...'
        response = HTTP.auth(:basic, authenticate_params).get(FEED_URL).body.to_s

        if response.empty?
          abort "Authroized failed. Please check your email & password in #{CREDENTIAL_FILE}"
        end

        if @feed_xml = response
          puts 'Authroized.'
          return true
        end
      end

      # Params for basic authentication
      def authenticate_params
        { user: credentials[:email], pass: credentials[:password] }
      end

      # RubyTapas subscription credentials (~/.rubytapas/.credentials)
      # @return [Hash]
      def credentials
        Subscription.new.to_h
      end

      # Parse raw feed data (XML), retrive episode's title and links.
      # @return [Array<Hash>]
      def parse_xml_feed
        puts 'Parsing Episodes...'

        require 'nokogiri'
        items = Nokogiri::XML(feed_xml).xpath('//item')

        epsiode_data = items.map do |item|
          children = item.children

          title       = (children / 'title').first.child.content
          description = (children / 'description').first.child.content

          links = Nokogiri::HTML(description).css('ul li a')

          { title: title, links: attachments(links) }
        end

        puts 'Episodes parsed successfully.'

        return epsiode_data
      end

      # Given links, parse to
      # { filename: "123.rb", "/subscriber/download?file_id=34567" }
      # @return [Array<Hash>]
      def attachments links
        links.each_with_object([]) do |link, episode|
          if link['href'] =~ /rubytapas.dpdcart.com\/subscriber\/download/
            episode << { filename: link.content, link: link['href'].gsub(/#{BASE_URL}/, '') }
          end
        end
      end

      # Write episodes data to ~/.rubytapas/episodes.json
      def save_feed_data feed
        puts 'Saving episodes data to ~/.rubytapas/episodes.json...'
        EPISODES_JSON_FILE.write feed.to_json
        puts 'Saved.'
      end

      # Return each episode's folder name
      def sanitized title
        dasherize_file_name(title)
      end

      # Before: 999 Array.first, Foo::Bar, Class<<self
      # After:  999-array-first-foo-bar-class<<self
      def dasherize_file_name file_name
        file_name.downcase.gsub('&lt;', '<').gsub(/[^\w<>#?!$]+/, '-')
      end

      # Form params to post for HTTP
      # @return [Hash]
      def form_params
        { form: { username: credentials[:email], password: credentials[:password] } }
      end

      # If the episodes json was made of 259_200.seconds.ago (3 days)
      # @return [Boolean] true if episodes.json creation time < 3 days
      def fresh?
        return false unless EPISODES_JSON_FILE.exist?
        Time.now - EPISODES_JSON_FILE.ctime < 259_200
      end
  end
end
