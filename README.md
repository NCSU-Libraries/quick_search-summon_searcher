# QuickSearch Summon Searcher

## Description

This is a gem engine implementing a Summon searcher for QuickSearch.

In addition to providing Summon results, the searcher can provide:

* Spelling Suggestions
* Related Topics
* Topic Snippets

These services can be enabled / disabled by adding / removing them from the "services" configuration option in summon_config.yml.

> Note: This gem was extracted from NCSU Libraries' implementation of QuickSearch, and although some aspects have been made configurable, there may be still be some assumptions baked into the searcher. Issues or pull requests are welcome if you run into this situation.


## Usage

To use, add 'quick_search-summon_searcher' to your QuickSearch Gemfile, add the searcher to quick_search_config.yml, and add a render_module call into the app/views/search/index.html.erb results page.

For more general information about setting up searcher plugins in QuickSearch, see https://github.com/NCSU-Libraries/quick_search

## Configuration

Configuration for the searcher is found in config/summon_config.yml. To override the default configuration, copy summon_config.yml to your QuickSearch application's config directory: <my_app>/config/searchers/summon_searcher.yml, then modify that version.

You need to supply your API keys to summon_config.yml in order to allow the searcher to make requests to the Summon API. Additionally, you'll want to configure the commands and filters that are applied to the API response and link into the Summon search results page respectively. These are also set in summon_config.yml, and map to values for filters in the Summon API URL or search results page URL. You can see examples in the default summon_config.yml: https://www.github.com/ncsu-libraries/quick_search-summon_searcher/blob/master/config/summon_config.yml

For more information about commands and filters, look at the Summon API documentation: https://api.summon.serialssolutions.com/help/api/search/commands
