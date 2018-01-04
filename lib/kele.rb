require 'httparty'
require 'json'
require './lib/roadmap'

class Kele
  include HTTParty
  include JSON
  include Roadmap

  def initialize(e, p)
    @base_uri = 'https://www.bloc.io/api/v1'
    response = self.class.post("#{@base_uri}/sessions", body: {"email": e, "password": p})
    @auth_token = response['auth_token']
  end

  def get_me
    response = self.class.get("#{@base_uri}/users/me", headers: { "authorization" => @auth_token })
    JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id = nil)
    if mentor_id == nil
      response = get_me
      mentor_id = response["current_enrollment"]["mentor_id"]
    end
    response = self.class.get("#{@base_uri}/mentors/#{mentor_id}/student_availability", headers: { "authorization" => @auth_token })
    JSON.parse(response.body)
  end

end
