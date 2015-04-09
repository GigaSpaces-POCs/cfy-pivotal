require 'socket'

module PagesHelper

  def ip_addy
    ip=Socket.ip_address_list.detect{|intf| intf.ipv4_private?}
    ip.ip_address if ip
  end

  def hostname
    request.host
  end

end
