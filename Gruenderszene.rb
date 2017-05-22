require 'rubygems'
require 'mechanize'
require 'nokogiri'
require 'openssl'
require 'open-uri'

# Handle typical SSL errors
I_KNOW_THAT_OPENSSL_VERIFY_PEER_EQUALS_VERIFY_NONE_IS_WRONG = nil
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

#create agent
agent = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari 4' }
agent.follow_meta_refresh = true

#visit page
counter = 0
maxpages = 3

companyArray = Array.new

while counter < maxpages do

   doc = Nokogiri::HTML(agent.get("https://www.gruenderszene.de/jobboerse/?seite=" + (counter).to_s).content)
   results = doc.css('p[class="job_company_town"]')
   alts = results.map {|res| res.inner_html.to_s}.uniq.sort.delete_if {|res| res.empty?}

   alts.each do |ind|
    dubbo = ind.split("<br")[0]
   companyArray.push(dubbo)
  end
   counter = counter + 1
end

companyArray.each do |indiv|
  puts indiv
end
