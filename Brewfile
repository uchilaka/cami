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
brew 'gnupg'
brew 'git-crypt'
brew 'yq'
brew 'vips'
brew 'postgresql@15'

# install only on specified OS
if OS.mac?
  brew 'tree'
  brew 'gnutls'
  brew 'foreman'
  cask 'ngrok'
  brew 'pinentry-mac'
end

# FYI: Brew cask only works on macOS
if File.exist?('/usr/local/bin/docker')
  puts 'Found Docker installed 🥳 - skipping docker installation'
elsif OS.mac?
  puts 'Setting up Rancher Desktop (an open source Docker Desktop alternative)'
  cask 'rancher'
end
cask 'keepassxc'
