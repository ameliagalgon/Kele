require 'httparty'

class Kele
  include HTTParty

  def initialize(e, p)
    @base_uri = 'https://www.bloc.io/api/v1'
    response = self.class.post("#{@base_uri}/sessions", body: {"email": e, "password": p})
    @auth_token = response['auth_token']
  end

end
