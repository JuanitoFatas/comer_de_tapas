require 'pathname'

module ComerDeTapas
  BASE_URL     = 'https://rubytapas.dpdcart.com'
  DOWNLOAD_URL = BASE_URL + '/subscriber/download'
  LOGIN_URL    = BASE_URL + '/subscriber/login'
  FEED_URL     = BASE_URL + '/feed'

  RUBYTAPAS_DIR      = Pathname.new(ENV['HOME']).join('.rubytapas')
  EPISODES_JSON_FILE = RUBYTAPAS_DIR.join('episodes.json')
  CREDENTIAL_FILE    = RUBYTAPAS_DIR.join('.credentials')
end
