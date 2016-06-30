class Level1Service < LevelService
  def perform
    ResultLevel1.new(@data_struc).to_json
  end
end
