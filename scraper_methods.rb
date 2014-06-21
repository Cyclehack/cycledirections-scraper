require 'httparty'
require 'nokogiri'
require 'open-uri'
require 'csv'

API_KEY = "blahblah" #git an api key for google places 
 
@venues = []
 
@searches = [
"https://maps.googleapis.com/maps/api/place/textsearch/xml?query=food+in+Glasgow&sensor=false&key=#{API_KEY}",
"https://maps.googleapis.com/maps/api/place/textsearch/xml?query=shops+in+Glasgow&sensor=false&key=#{API_KEY}",
"https://maps.googleapis.com/maps/api/place/textsearch/xml?query=gallery+in+Glasgow&sensor=false&key=#{API_KEY}",
"https://maps.googleapis.com/maps/api/place/textsearch/xml?query=gyms+in+Glasgow&sensor=false&key=#{API_KEY}",
"https://maps.googleapis.com/maps/api/place/textsearch/xml?query=bars+in+Glasgow&sensor=false&key=#{API_KEY}",
"https://maps.googleapis.com/maps/api/place/textsearch/xml?query=colleges+in+Glasgow&sensor=false&key=#{API_KEY}",
"https://maps.googleapis.com/maps/api/place/textsearch/xml?query=unversity+in+Glasgow&sensor=false&key=#{API_KEY}",
"https://maps.googleapis.com/maps/api/place/textsearch/xml?query=library+in+Glasgow&sensor=false&key=#{API_KEY}",
"https://maps.googleapis.com/maps/api/place/textsearch/xml?query=clinic+in+Glasgow&sensor=false&key=#{API_KEY}",
"https://maps.googleapis.com/maps/api/place/textsearch/xml?query=hospital+in+Glasgow&sensor=false&key=#{API_KEY}",
"https://maps.googleapis.com/maps/api/place/textsearch/xml?query=cinema+in+Glasgow&sensor=false&key=#{API_KEY}",
"https://maps.googleapis.com/maps/api/place/textsearch/xml?query=community+centres+in+Glasgow&sensor=false&key=#{API_KEY}"
]
 
def append_to_venues_hash(results)
  puts "\n\nChecking #{results.size} results"
   
  for result in results
    search_query = "Directions to #{result['name']}, Glasgow"
    search_query = search_query.gsub(' ', '+')
    search_url = "https://www.google.co.uk/search?client=ubuntu&channel=fs&q=#{search_query}&ie=utf-8"
    search_url = URI.escape(search_url)
     
    puts "Searching for #{search_query}"
     
    data = Nokogiri::HTML(open(search_url))
    directions_url = "http://" + data.at_css("cite").text
    directions_url = directions_url.gsub(' ', '')
    directions_url = URI.escape(directions_url)
     
    #can_check = directions_url =~ /\A#{URI::regexp(['http', 'https'])}\z/
    puts "Checking out #{directions_url}"
     
    begin
    data = Nokogiri::HTML(open(directions_url))
    site_text = data.text.downcase
    has_cycling = site_text.include?("cycling") or site_text.include?("bike") or site_text.include?("cycle")
    has_directions = site_text.include?("walk") or site_text.include?("bus") or site_text.include?("train") or site_text.include?("car")
     
    @venues << { :name => result['name'], :address => result["formatted_address"], :directions_site => directions_url, :could_scrape => true, :has_cycling => has_cycling, :has_directions => has_directions }
    rescue
    puts "error"
    @venues << { :name => result['name'], :address => result["formatted_address"], :directions_site => directions_url, :could_scrape => false, :has_cycling => nil, :has_directions => nil }
    end
  end
end
 
def write_results
  CSV.open("public/cycle_directions.csv", "wb") do |csv|
    csv << ["name", "address", "directions_site", "could_scrape", "has_cycling", "has_directions"]
    for venue in @venues
      csv << [venue[:name], venue[:address], venue[:directions_site], venue[:could_scrape], venue[:has_cycling], venue[:has_directions]]
    end
  end
end
 
def tha_scrape_yo
  for search in @searches
    r=HTTParty.get(search)
    append_to_venues_hash(r.parsed_response["PlaceSearchResponse"]["result"])
  end
end