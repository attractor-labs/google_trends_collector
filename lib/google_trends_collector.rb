# encoding: utf-8
class GoogleTrendsCollector

  def initialize(config = {})
    if config[:headless] == true
      @headless.start
      @headless = Headless.new
    end
    @browser = Watir::Browser.new :firefox, profile: "foo"
  end

  def import(query)
    response = hash_query_response(query)
    @browser.close
    return response
  end

  def hash_query_response(query)
    parse trends_request(query)
  end

  def get_popularity(popularity_part)
    /\"v\"\:([0-9\.]+)\,/.match(popularity_part)[1].to_f
  end

  def get_time(date_part)
    time_params = /\((.+)\)/.match(date_part)[1].split(",").map(&:to_i)
    time_params[1] = time_params[1] + 1
    return DateTime.new(time_params[0],time_params[1],time_params[2])
  end

  def date_popularity_pair(atom)
    atom.split("},{")
  end

  def atomize_by_dates(filtered_output)
    filtered_output.split(']},{')
  end

  def filter_popular(output)
    output.split('"rows":').last
  end

  def parse_popular(output)
    filtered_output = filter_popular(output)
    result_hash = {}
    atomize_by_dates(filtered_output).each do |atom|
      pair = date_popularity_pair(atom)
      result_hash[get_time(pair[0])] = get_popularity(pair[1])
    end
    return result_hash
  end

  def parse_unpopular(output)
    {error: "unpopular"}
  end

  def parse_banned(output)
    {error: "banned"}
  end

  def parse(output)
    output = output.force_encoding("ASCII-8BIT").encode('UTF-8', undef: :replace, replace: '')
    return parse_popular(output)   if popular?(output)
    return parse_unpopular(output) if unpopular?(output)
    return parse_banned(output)    if banned?(output)
  end

  def unpopular?(output)
    output[/Could not complete request/, 0] != nil
  end

  def popular?(output)
    output[/\"rows\"\:\[\{\"c\"\:\[\{\"v\"\:new Date\(/, 0] != nil
  end

  def banned?(output)
    unpopular?(output) == false && popular?(output) == false
  end

  def trends_request(query)
    query_param = CGI::escape query
    @browser.goto "http://www.google.com/trends/fetchComponent?q=#{query_param}&cid=TIMESERIES_GRAPH_0&export=3"
    @browser.text
  end
end
