# frozen_string_literal: true

require 'fileutils'

# set arguments for all 'brew install --cask' commands
cask_args appdir: '~/Applications', require_sha: true

# brew install
brew 'tree'
brew 'direnv'
tap 'heroku/brew' || true
brew 'heroku'
brew 'ruby-build'
brew 'asdf'
brew 'coreutils'
brew 'git-crypt'
brew 'yq'

# install only on specified OS
brew 'tree' if OS.mac?
brew 'gnutls' if OS.mac?
brew 'foreman' if OS.mac?

# FYI: Brew cask only works on macOS
if File.exist?('/usr/local/bin/docker')
  puts 'Found Docker installed 🥳 - skipping docker installation'
else
  cask 'docker' if OS.mac?
end
cask 'ngrok' if OS.mac?
