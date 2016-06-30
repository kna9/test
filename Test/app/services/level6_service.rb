class Level6Service < LevelService
  def perform
    ResultLevel6.new(@data_struc).to_json
  end
end
