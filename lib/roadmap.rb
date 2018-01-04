require 'httparty'
require 'json'

module Roadmap

  def get_roadmap(roadmap_id = nil)
    if roadmap_id == nil
      response = get_me
      roadmap_id = response["current_program_module"]["roadmap_id"]
    end
    response = self.class.get("#{@base_uri}/roadmaps/#{roadmap_id}", headers: { "authorization" => @auth_token })
    JSON.parse(response.body)
  end

  def get_checkpoint(checkpoint_id)
    response = get_roadmap
    sections = response["sections"]
    checkpoints = []
    sections.each do |section|
      checkpoints.concat(section["checkpoints"])
    end
    checkpoints.each do |checkpoint|
      if checkpoint["id"] == checkpoint_id
        return checkpoint
      end
    end
    return []
  end

end
