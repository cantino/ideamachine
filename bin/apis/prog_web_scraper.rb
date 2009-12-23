require "rubygems"
require "parsley"
require "open-uri"
require "pp"

json_string = <<-STR
  {
    "apis (tr)": [ {
      "name?": "td:nth-child(1)",
      "url?": "td:nth-child(1) a @href",
      "description?": "td:nth-child(2)",
      "category?": "td:nth-child(3)"
    } ]
  }
STR

cache_file = File.join(File.dirname(__FILE__), "programmableweb.html")
if File.exist?(cache_file)
  content = File.read(cache_file)
else
  content = open("http://www.programmableweb.com/apis/directory").read
  File.open(cache_file, 'w') do |file|
    file.print content
  end
end

parselet = Parsley.new(json_string)
data = parselet.parse(:string => content)
data['apis'].each do |api|
  desc = api['description'] && api['description'].strip.squeeze(" ")
  name = api['name'] && api['name'].strip.squeeze(" ")
  url = api['url'] && api['name'].strip
  text = "#{name} #{desc}".gsub(/((\w+)(\s+\2)+)/, '\2')
  text = "#{name}".gsub(/((\w+)(\s+\2)+)/, '\2')
  next unless url
  if text =~ /\bAPI\b/i
    puts "API  <a href='#{url}' target='_blank'>#{text}</a>"
  else
    puts "API  <a href='#{url}' target='_blank'>#{text} API</a>"
  end
end
