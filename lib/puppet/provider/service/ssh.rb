require 'net/ssh'
require 'puppet_x/puppetlabs/transport'
require 'puppet_x/puppetlabs/transport/ssh'

Puppet::Type.type(:service).provide(:ssh) do
  confine :feature => :ssh

  include PuppetX::Puppetlabs::Transport

  def initd_cmd
    "/etc/init.d/#{resource[:name]}"
  end

  def pattern
    resource[:pattern] || '[started|running]$'
  end

  def status
    cmd = resource[:status] || "#{initd_cmd} status"

    result = transport.exec!("#{cmd}; echo $?").split("\n").last

    if result == '0'
      :running
    else
      :stopped
    end
  end

  def restart
    cmd = resource[:restart] || "#{initd_cmd} restart"
    transport.exec!(cmd)
  end

  def start
    cmd = resource[:start] || "#{initd_cmd} start"
    transport.exec!(cmd)
  end

  def stop
    cmd = resource[:stop] || "#{initd_cmd} stop"
    transport.exec!(cmd)
  end
end
