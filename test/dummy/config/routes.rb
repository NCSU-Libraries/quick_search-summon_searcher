Rails.application.routes.draw do

  mount QuickSearchSummonSearcher::Engine => "/quick_search_summon_searcher"
end
