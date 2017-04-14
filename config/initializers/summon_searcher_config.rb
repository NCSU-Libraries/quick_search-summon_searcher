# Try to load a local version of the config file if it exists - expected to be in quick_search_root/config/searchers/summon_config.yml
if File.exists?(File.join(Rails.root, "/config/searchers/summon_config.yml"))
  config_file = File.join Rails.root, "/config/searchers/summon_config.yml"
else
  # otherwise load the default config file
  config_file = File.expand_path("../../summon_config.yml", __FILE__)
end
QuickSearch::Engine::SUMMON_CONFIG = YAML.load_file(config_file)[Rails.env]
