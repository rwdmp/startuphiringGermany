
require 'rubygems'
require 'mechanize'
require 'nokogiri'
require 'openssl'
require 'open-uri'
def extractPageItemContent(pageitem)
  blob = Nokogiri::HTML(pageitem)
  companyName  = blob.css('div div div').inner_html.split(",")[0].strip
  companyCity  = blob.css('div div div').inner_html.split(",")[1].split("(")[0].strip
  jobType      = blob.css('div div div').inner_html.split(",")[2].strip
  jobTitle     = blob.css('div div a').inner_text.to_s
  jobDescr     = blob.css('div[class="show-brief"]').inner_html.gsub('"','').strip.gsub('  ',' ')
  publicDate   = blob.css('span').inner_html.gsub('Veröffentlicht: ','').strip
  result       = [companyName, companyCity, publicDate, jobTitle]
  return result
end

# Handle typical SSL errors
I_KNOW_THAT_OPENSSL_VERIFY_PEER_EQUALS_VERIFY_NONE_IS_WRONG = nil
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

#create agent
agent = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari 4' }
agent.follow_meta_refresh = true

#visit page
counter = 0
maxpages = 5

companyArray = Array.new

while counter < maxpages do

   doc = Nokogiri::HTML(agent.get("https://www.startup-jobs-germany.com/search-results-jobs/?page=" + counter.to_s + "&view=list").content)
   results = doc.css('div[class="listing-section "]')

   alts = results.map {|res| res.inner_html.to_s}.uniq.sort.delete_if {|res| res.empty?}
   alts.each do |ind|
    companyArray.push (extractPageItemContent(ind))
   end
   counter = counter + 1
end

companyArray.each do |output|
  puts output.to_s
end



# Function
