require 'json'

class Level5Controller < ApplicationController
  def initialize
    @level = :level5

    super
  end

  def view
  	begin
      render json: Level5Service.new(file).perform
    rescue
      raise 'error processing json'
    end
  end 
end
