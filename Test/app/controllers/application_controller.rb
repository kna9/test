class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def file
  	begin
      File.read(data_file_name)
    rescue
      raise 'unable to read source file'
    end
  end

  def data_file_name
  	"data-#{@level.to_s}.json"
  end
end
