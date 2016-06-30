class Level3Service < LevelService
  def perform
    ResultLevel3.new(@data_struc).to_json
  end
end
