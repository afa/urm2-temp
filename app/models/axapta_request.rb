require 'json_rpc_client'
class AxaptaRequest < JsonRpcClient
 #json_rpc_service 'http://192.168.0.72:20013/jsonrpc2', :no_auto_config => true
 #json_rpc_service 'http://192.168.0.72:20013/jsonrpc', :no_auto_config => true
 # nginx json_rpc_service 'http://172.16.200.40/jsonrpc_test', :no_auto_config => true
 #json_rpc_service 'http://192.168.0.72:7077/', :no_auto_config => true, :uri_encode_post_bodies => true
 json_rpc_service 'http://172.16.200.40/jsonrpc_debug', :no_auto_config => true, :uri_encode_post_bodies => true
  def self.method_missing(name, *args)
   begin
    key = "json_rpc-#{Time.now.to_f}"
    strt = Stat::Event.create(:type => "Stat::Before", :key => key, :name => name, :data => args.to_json)
    rslt = super
    Stat::Event.create(:type => "Stat::Done", :key => key, :name => name, :data => rslt.to_json)
    return rslt
   rescue JsonRpcClient::NotAService => e
    Stat::Event.create(:type => "Stat::Exception", :key => key, :name => "JsonRpcClient::NotAService", :data => [e.to_s, e.backtrace].to_json)
    begin
     strt = Stat::Event.create(:type => "Stat::Rescue", :key => key, :name => name, :data => args.to_json)
     rslt = super
     Stat::Event.create(:type => "Stat::Done", :key => key, :name => name, :data => rslt.to_json)
     return rslt
    rescue Exception => e
     Stat::Event.create(:type => "Stat::Exception", :key => key, :name => "JsonRpcClient::NotAService", :data => [e.to_s, e.backtrace].to_json)
     raise
    end
   rescue Exception => e
    Stat::Event.create(:type => "Stat::Exception", :key => key, :name => e.to_s, :data => [e.to_s, e.backtrace].to_json)
    raise
   end
  end 
end
