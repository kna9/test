require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'

describe Level1Service do
  it 'Returns Level1 result specified' do
    level1_result = JSON.parse(Level1Service.new(input_file(:level1)).perform)
    level1_expected = JSON.parse(output_file(:level1)) 
    expect(level1_result).to eql(level1_expected)
  end
end

describe Level2Service do
  it 'Returns Level2 result specified' do
    level2_result = JSON.parse(Level2Service.new(input_file(:level2)).perform)
    level2_expected = JSON.parse(output_file(:level2)) 
    expect(level2_result).to eql(level2_expected)
  end
end

describe Level3Service do
  it 'Returns Level3 result specified' do
    level3_result = JSON.parse(Level3Service.new(input_file(:level3)).perform)
    level3_expected = JSON.parse(output_file(:level3)) 
    expect(level3_result).to eql(level3_expected)
  end
end

describe Level4Service do
  it 'Returns Level4 result specified' do
    level4_result = JSON.parse(Level4Service.new(input_file(:level4)).perform)
    level4_expected = JSON.parse(output_file(:level4)) 
    expect(level4_result).to eql(level4_expected)
  end
end

describe Level5Service do
  it 'Returns Level5 result specified' do
    level5_result = JSON.parse(Level5Service.new(input_file(:level5)).perform)
    level5_expected = JSON.parse(output_file(:level5)) 
    expect(level5_result).to eql(level5_expected)
  end
end

# FIXME : Level6Service JSON to check (not defined)

def input_file(level)
  File.read("data-#{level.to_s}.json")
end

def output_file(level)
  File.read("output-#{level.to_s}.json")
end
