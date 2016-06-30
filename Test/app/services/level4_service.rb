class Level4Service < LevelService
  def perform
    ResultLevel4.new(@data_struc).to_json
  end
end
