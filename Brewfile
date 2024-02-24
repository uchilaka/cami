# frozen_string_literal: true

# set arguments for all 'brew install --cask' commands
cask_args appdir: '~/Applications', require_sha: true

# brew install
brew 'heroku'
brew 'ruby-build'
brew 'foreman'

# install only on specified OS
brew 'tree' if OS.mac?
brew 'gnutls' if OS.mac?

cask 'ngrok'
