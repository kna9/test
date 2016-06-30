require 'json'

class Level2Controller < ApplicationController
  def initialize
    @level = :level2

    super
  end

  def view
  	begin
      render json: Level2Service.new(file).perform
    rescue
      raise 'error processing json'
    end
  end
end
