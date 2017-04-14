$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "quick_search_summon_searcher/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "quick_search-summon_searcher"
  s.version     = QuickSearchSummonSearcher::VERSION
  s.authors     = ["Kevin Beswick"]
  s.email       = ["kdbeswic@ncsu.edu"]
  s.homepage    = "http://search.lib.ncsu.edu"
  s.summary     = "QuickSearch searcher for Summon"
  s.description = "QuickSearch searcher for Summon"

  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "quick_search-core", "~> 0"
  s.add_dependency "fastimage", "~> 2.1.0"
  s.add_dependency "summon", "~> 2.0.5"
end
