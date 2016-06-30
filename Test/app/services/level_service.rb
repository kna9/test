class LevelService
  def initialize(file)
    @data_struc = JSON.parse(file, object_class: OpenStruct)
  end
end
