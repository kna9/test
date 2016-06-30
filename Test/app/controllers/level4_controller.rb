require 'json'

class Level4Controller < ApplicationController
  def initialize
    @level = :level4

    super
  end

  def view
  	begin
      render json: Level4Service.new(file).perform
    rescue
      raise 'error processing json'
    end
  end 
end
