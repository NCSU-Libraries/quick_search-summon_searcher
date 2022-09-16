module QuickSearch
  class SummonSearcher < QuickSearch::Searcher

    attr_accessor :spelling_suggestion

    def search
      url = api_base_url + api_parameters.to_query
      raw_response = @http.get(url, {}, headers)
      @response = JSON.parse(raw_response.body)
    end

    def results
      if results_list
        results_list
      else
        pages = response['documents']
        @results_list = []
        pages.each do |value|
          result = OpenStruct.new
          result.title = title(value)
          result.link = link(value)
          result.format = format(value)
          result.description = description(value)
          result.citation = true
          result.author = author(value)
          result.date = date(value)
          result.publisher = publisher(value)
          result.volume = volume(value)
          result.issue = issue(value)
          result.pages = pages(value)
          result.fulltext = fulltext(value)

          if QuickSearch::Engine::SUMMON_CONFIG['show_thumbnails']
            result.thumbnail = thumbnail(value)
          end

          @results_list << result
        end
        @results_list
      end
    end

    def loaded_link
      loaded_link_base_url + loaded_link_parameters.to_query
    end

    def total
      response['recordCount']
    end

    # This returns the spelling suggestion for the whole app!
    def spelling_suggestion
      unless response['didYouMeanSuggestions'].blank?
        response['didYouMeanSuggestions'][0]['suggestedQuery']
      else
        ""
      end
    end

    def related_topics
      related_topics = []
      unless response['topicRecommendations'].blank?
        response['topicRecommendations'][0]['relatedTopics'].each do |topic|
          related_topics << topic['title']
        end
      end
      related_topics
    end

    def topic_snippet
      topic_snippet = {}
      unless response['topicRecommendations'].blank?
        topic_snippet['title'] = response['topicRecommendations'][0]['title']
        topic_snippet['snippet'] = response['topicRecommendations'][0]['snippet']
        topic_snippet['source_name'] = response['topicRecommendations'][0]['sourceName']
        topic_snippet['source_link'] = response['topicRecommendations'][0]['sourceLink']
      end
      topic_snippet
    end

  private

    def api_base_url
      QuickSearch::Engine::SUMMON_CONFIG['api_base']
    end

    def loaded_link_base_url
      QuickSearch::Engine::SUMMON_CONFIG['loaded_link_base']
    end

    def commands
      QuickSearch::Engine::SUMMON_CONFIG['commands']
    end

    def filters
      QuickSearch::Engine::SUMMON_CONFIG['filters']
    end

    def api_parameters
      api_parameters = {
        's.include.ft.matches' =>'f',
        's.cmd' => commands.join(' '),
        's.light' => 'true',
        's.pn' => '1',
        's.ps' => @per_page,
        's.q' => http_request_queries['not_escaped'],
        's.rec.topic.max' => '1'
      }

      if @on_campus
        api_parameters['s.role'] = 'authenticated'
      end

      api_parameters
    end

    def loaded_link_parameters
      {
        'fvf' => filters.join('|'),
        'q' => http_request_queries['not_escaped'],
        'l' => 'en',
        'keep_r' => 'true'
      }
    end

    def headers
      Summon::Transport::Headers.new(
        :url => api_base_url,
        :access_id => QuickSearch::Engine::SUMMON_CONFIG['access_id'],
        :client_key => QuickSearch::Engine::SUMMON_CONFIG['client_key'],
        :secret_key => QuickSearch::Engine::SUMMON_CONFIG['secret_key'],
        :accept => "json",
        :params => api_parameters
      )
    end

    def format(value)
      value['ContentType'][0] if value['ContentType']
    end

    def title(value)
      value['Title'][0] if value['Title']
    end

    def link(value)
      value['link'] if value['link']
    end

    def description(value)
      value['Abstract'][0] if value['Abstract']
    end

    def author(value)
      authors = ''
        if value['Author_xml']
          value['Author_xml'].each do |author|
            authors << author['fullname'] if value['Author_xml']
            authors << '; '
        end
      end
      authors.chomp('; ')
    end

    def date(value)
      value['PublicationDate_xml'][0]['year'] if value['PublicationDate_xml']
    end

    def publisher(value)
      value['PublicationTitle'][0].titleize if value['PublicationTitle']
    end

    def volume(value)
        value['Volume'][0] if value['Volume']
    end

    def issue(value)
      value['Issue'][0] if value['Issue']
    end

    def fulltext(value)
      value['hasFullText'] ? true : false
    end

    def page_start(value)
      if value['StartPage']
        Integer(value['StartPage'][0]) rescue nil
      end
    end

    def page_end(value)
      if value['EndPage']
        Integer(value['EndPage'][0]) rescue nil
      end
    end

    def pages(value)
      page_start = page_start(value)
      page_end = page_end(value)
      if page_end && page_start && page_end > page_start
        formatted_page = "#{page_start}&nbsp;-&nbsp;#{page_end}"
      elsif page_start
        formatted_page = "#{page_start}"
      end
    end

    def thumbnail(value)
      if value['thumbnail_s']
        image_size = FastImage.size(value['thumbnail_s'][0], :timeout => 0.1)
        unless image_size.nil?
          if image_size.first > 1
            thumbnail = value['thumbnail_s'][0].sub! "http://www.", "//"
          end
        end
      end

      thumbnail
    end

  end
end
