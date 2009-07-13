# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_salsawithus_session',
  :secret      => '422bd7551e4284331897e2e02fa87586eeb854fc471a1bbd6a5001e95034f2f988e1c5254c33e00ed5bd8f16d9de922309c195f7639354fd0b44c05cf4861186'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
