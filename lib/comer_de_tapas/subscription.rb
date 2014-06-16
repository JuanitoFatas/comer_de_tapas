module ComerDeTapas
  class Subscription
    KEYS = %w(email password save_path)

    def initialize
      abort 'Please run `comer_de_tapas init` first' unless File.exist? CREDENTIAL_FILE

      set_subscription_data if subscription_data_valid?
    end

    # @return [Hash] User's Ruby Tapas credential information
    def to_h
      { email: email, password: password, save_path: save_path }
    end

    private

      attr_reader :email, :password, :save_path

      # Load ~/.rubytapas/.credentials yaml
      def load_credential_data
        require 'yaml'
        @credential_yaml ||= YAML.load_file CREDENTIAL_FILE
      end

      # Return true if ~/.rubytapas/.credentials files are filled and correct.
      # @return [Boolen]
      def subscription_data_valid?
        # empty credential file's size is about 50-55.
        # 65 is when you have a very short email, password, and save_path.
        # So when you filled in data, probably will > 65.
        if File.size(CREDENTIAL_FILE) < 65
          puts "Did you fill in your subscription data in #{CREDENTIAL_FILE}?"
          return false
        end

        credential_data_valid?(get_validate load_credential_data)
      end

      # Return true if passed-in data all match criteria.
      # @return [Boolen]
      def credential_data_valid? data
        data.each do |hash|
          hash.each do |k,v|
            abort <<-MSG unless KEYS.include? k
Probably have a typo in #{CREDENTIAL_FILE}: #{k}
Valid yaml keys: #{KEYS.join(', ')}.
            MSG
            abort "Please fill in #{k} in #{CREDENTIAL_FILE}" unless v
          end
        end

        return true
      end

      # Get credential data from loaded yaml for validation.
      def get_validate data
        data.values.flatten
      end

      # Set subscription data from ~/.rubytapas/.credentials yaml
      def set_subscription_data
        @email     ||= load_credential_data['credentials'][0]['email']
        @password  ||= load_credential_data['credentials'][1]['password']
        @save_path ||= load_credential_data['credentials'][2]['save_path']
      end
  end
end
