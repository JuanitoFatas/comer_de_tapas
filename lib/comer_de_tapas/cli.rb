require 'thor'

module ComerDeTapas
  class CLI < Thor
    def initialize(*)
      @client = Client.new
      super
    end

    desc 'version', 'Show version'
    def version
      say VERSION
    end
    map %w[-v --version] => :version

    desc 'init', 'Create config folder and files'
    def init
      @client.init!
      say 'Please fill in your subscription info in ~/.rubytapas/.credentials'
    end

    # -f, --force, options[:force] => true, otherwise nil.
    desc 'download', 'Download RubyTapas episodes'
    method_option 'force', :aliases => '-f', type: :boolean, desc: 'Force download.'
    def download
      @client.fetch_episodes!(options[:force])
      @client.prepare_save_folder!
      @client.authenticate
      @client.load_episodes
      @client.download_all_tapas!
    end
  end
end
