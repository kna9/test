require 'json'

class Level3Controller < ApplicationController
  def initialize
    @level = :level3

    super
  end

  def view
  	begin
      render json: Level3Service.new(file).perform
    rescue
      raise 'error processing json'
    end
  end 
end
