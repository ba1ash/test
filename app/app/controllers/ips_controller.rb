class IpsController < ApplicationController
  def list
    GetWeirdIps.new.call(nil) do |matcher| 
      matcher.success { |ips| render(status: 200, json: ips) }
      matcher.failure {}
    end
  end
end
