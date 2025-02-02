# frozen_string_literal: true

require 'rbconfig'

module OperatingSystemDetectable
  # Check OS with Ruby: https://gist.github.com/havenwood/4161944
  def mac?
    friendly_os_name == :macos
  end

  def linux?
    friendly_os_name == :linux
  end

  def human_friendly_os_name
    human_friendly_os_names_map[friendly_os_name]
  end

  def friendly_os_name
    case RbConfig::CONFIG['host_os']
    when /linux/
      :linux
    when /darwin/
      :macos
    when /mswin|mingw32|windows/
      :windows
    when /solaris/
      :solaris
    when /bsd/
      :bsd
    else
      :unsupported
    end
  end

  def human_friendly_os_names_map
    {
      linux: 'Linux',
      macos: 'macOS',
      windows: 'Windows',
      solaris: 'Solaris',
      bsd: 'BSD',
      unsupported: 'Unsupported'
    }
  end
end
