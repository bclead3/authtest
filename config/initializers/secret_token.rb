# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
#Authtest::Application.config.secret_token = '1c7cf19825c6ee41d5eca431563887e4a4eb0d9ab451c1be148d1a252ec5f475cddf7c1176888fb967da3840bdb80a033c7c299dac0661075b584981b415f1b2'

require 'securerandom'

def secure_token
  token_file = Rails.root.join('.secret')
  if File.exist?(token_file)
    # Use the existing token.
    File.read(token_file).chomp
  else
    # Generate a new token and store it in token_file.
    token = SecureRandom.hex(64)
    File.write(token_file, token)
    token
  end
end

Authtest::Application.config.secret_token = secure_token