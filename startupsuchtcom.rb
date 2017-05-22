require 'rubygems'
require 'mechanize'
require 'nokogiri'
require 'open-uri'


#create agent
agent = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari 4' }
agent.follow_meta_refresh = true
#visit page

counter = 0
maxpages = 3

companyArray = Array.new

while counter < maxpages do


   doc = Nokogiri::HTML(agent.get("https://startupsucht.com/startup_job?c=ALL&from=" + (counter * 30).to_s).content)
   results = doc.css('img')
   alts = results.map {|res| res.attribute('alt').to_s}.uniq.sort.delete_if {|res| res.empty?}

   alts.each do |ind|
   companyArray.push(ind)
  end
   counter = counter + 1
end

companyArray.each do |indiv|
  puts indiv
end
