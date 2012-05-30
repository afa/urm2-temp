require 'json_rpc_client'
class AxaptaRequest < JsonRpcClient
    #json_rpc_service 'http://192.168.0.72:20013/jsonrpc2', :no_auto_config => true
    #json_rpc_service 'http://192.168.0.72:20013/jsonrpc', :no_auto_config => true
    # nginx json_rpc_service 'http://172.16.200.40/jsonrpc_test', :no_auto_config => true
    json_rpc_service 'http://192.168.0.72:7077/', :no_auto_config => true
end
