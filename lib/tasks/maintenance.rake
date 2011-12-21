=begin
def config
   @config ||= AxaptaRequest.describe_methods("id"=>rand(10**6))
  end
=end

