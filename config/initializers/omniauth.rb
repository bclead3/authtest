Rails.application.config.middleware.use OmniAuth::Builder do
  # The following is for facebook
  provider :facebook, ENV['FACEBOOK_APP_ID'] , ENV['FACEBOOK_SECRET'] , {scope: 'email, read_stream, read_friendlists, friends_likes, friends_status, offline_access'}
end