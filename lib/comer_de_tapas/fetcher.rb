require 'celluloid/io'

module ComerDeTapas
  class Fetcher
    include Celluloid::IO

    # Fetch url with given cookie, and query string (optional)
    # @param [String] url
    # @param cookie
    # @option query [Hash]
    def fetch url, cookie, query={}
      require 'http'
      HTTP.with('Cookie' => cookie).get(url, ssl_socket_class: Celluloid::IO::SSLSocket, params: query)
    end
  end
end
