class Level2Service < LevelService
  def perform
    ResultLevel2.new(@data_struc).to_json
  end
end
