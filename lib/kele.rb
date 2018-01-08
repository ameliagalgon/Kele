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

  def get_messages(page_number = 1)
    response = self.class.get("#{@base_uri}/message_threads", body: {"page": page_number}, headers: { "authorization" => @auth_token })
    JSON.parse(response.body)
  end

  #create a new message thread: ex. 'subject: "New Message Subject"'
  #create a new message in an existing message thread: ex. 'token: "abcs"'
  def create_message(sender, recipient_id, stripped_text, args)
    if args[:token].nil?
      puts "HELLO!"
      response = self.class.post("#{@base_uri}/messages", body: { "sender": sender, "recipient_id": recipient_id, "subject": args[:subject], "stripped-text": stripped_text }, headers: { "authorization" => @auth_token })
    else
      response = self.class.post("#{@base_uri}/messages", body: { "sender": sender, "recipient_id": recipient_id, "token": args[:token], "stripped-text": stripped_text }, headers: { "authorization" => @auth_token })
    end
  end

  def create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment = "")
    response = get_me
    enrollment_id = response['id']
    response = self.class.post("#{@base_uri}/checkpoint_submissions", body: { "assignment_branch": assignment_branch, "assignment_commit_link": assignment_commit_link, "checkpoint_id": checkpoint_id, "comment": comment, "enrollment_id": enrollment_id })
  end

end
