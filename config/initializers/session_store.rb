# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_ideamachine_session',
  :secret      => '6b07010d4a4b24925133f231d3931c1e0285775d25ee824ece78cd96412c09a9bd93c5b0030d0a867a0d739bcb383233351902326ee8db454732087b8e1dd94b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
