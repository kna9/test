class Level5Service < LevelService
  def perform
    ResultLevel5.new(@data_struc).to_json
  end
end
