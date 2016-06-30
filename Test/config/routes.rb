Rails.application.routes.draw do
  get 'level1/output' => 'level1#view'
  get 'level2/output' => 'level2#view'
  get 'level3/output' => 'level3#view'
  get 'level4/output' => 'level4#view'
  get 'level5/output' => 'level5#view'
  get 'level6/output' => 'level6#view'
end
