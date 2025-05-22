class ApplicationController < ActionController::Base
  before_action :track_visit_time
  before_action :track_page_visits
  helper_method :last_visit_ago, :page_visit_count, :total_visit_count, :time_based_greeting
  before_action :track_last_visit

  private

  def track_last_visit
    @last_visit = session[:last_visit]
    session[:last_visit] = Time.current
  end
  

  def track_visit_time
    session[:last_visited_at] ||= Time.current
  end
  
  def last_visit_ago
    last = session [:last_visited_at]
    return "THIS IS YOUR 1ST VISIT!" unless last
    
    distance = distance_of_time_in_words(Time.current, Time.parse(last.to_s))
    "last_visited: #(distance) ago"
  end
  
  def track_page_visits
    session[:page_visits] ||= {}
    session[:total_visits] ||= 0

    page = request.path 
    session[:page_visits][page] = session[:page_visits][page].to_i + 1
    session[:total_visits] += 1
    session[:last_visited_at] = Time.current
  end

  def page_visit_count
    session[:page_visits][request.path].to_i
  end
  def total_visit_count
    session[:total_visits].to_i
  end
  def time_based_greeting
    hour = Time.current.hour
    case hour
    when 5..9 
     "GOOD MORNING!"
    when 10..14 
     "GOOD AFTERNOON!"
    when 15..18 
     "GOOD EVENING!"
    else 
      "GOOD NIGHT!"
      
  end
end

  include ActionView::Helpers::DateHelper
end
