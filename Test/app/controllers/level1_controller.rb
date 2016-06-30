

class Level1Controller < ApplicationController
  def initialize
    @level = :level1

    super
  end

  def view
  	begin
      render json: Level1Service.new(file).perform
    rescue
      raise 'error processing json'
    end
  end
end
