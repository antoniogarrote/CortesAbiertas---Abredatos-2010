# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_cortes_abiertas_session',
  :secret      => 'afa03e5c9067a38c2921dede0c216327e813b59f3c676e48c59204801b4090449c821fee6aae41d82197b164b2028d45129c414441d8825450356a27a7b3fa5e'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
