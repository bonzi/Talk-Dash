require 'httparty'
require 'json'
require 'time'
require 'uri'

def time_conversion(minutes)
    hours = minutes / 60
    rest = minutes % 60
    puts "#{hours}:#{rest}" 
end

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', :first_in => 0 do |job|

  request = HTTParty.get('https://api.joind.in/v2.1/talks/26818?verbose=yes', :headers => { 'Content-Type' => 'application/json' })
  response = JSON.parse(request.body)
  puts response

  for talk in response["talks"]
    if talk["start_date"] > Time.now.iso8601 #+ (talk["duration"],)
      title = talk["talk_title"]
      speaker = "Speaker Here"

      qr = "https://chart.googleapis.com/chart?cht=qr&chs=300x300&choe=UTF-8&chld=H|1&chl=" + talk["website_uri"] + "?qr"
      puts title + "\n" + qr
      send_event('nextUp', { text: title, moreinfo: speaker })
      send_event('nextUpQr', { image: qr })

    else
      puts "next"
    end
  end


  send_event('whatsOn', { text: "Jeff" })
  #send_event('nextUp', { text: "Geoffery" })
end
