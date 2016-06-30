require 'json'

class Level6Controller < ApplicationController
  def initialize
    @level = :level6

    super
  end

  def view
  	begin
      render json: Level6Service.new(file).perform
    rescue
      raise 'error processing json'
    end
  end
end
