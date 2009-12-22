#!/usr/bin/env ruby
require 'rubygems'
require 'linguistics'
Linguistics::use( :en )

module MadLib
  class OutOfOptions < RuntimeError; end
  class OutOfOptionsRetry < RuntimeError; end
  
  class Constructor
    def initialize(templates)
      if templates.is_a?(String)
        init_from_string(templates)
      else
        @patterns = templates
      end
    end
  
    def init_from_string(templates)
      @patterns = {}
      templates.each_line do |line|
        next if line.strip =~ /^#|^\s*$/
        if line.strip =~ /^([\w\_\d]+)\s+(.*)$/i
          @patterns[$1] ||= []
          @patterns[$1] << $2
        else
          puts "Don't understand: #{line}"
        end
      end
    end

    def pick(key, blocked = {})
      choices = (@patterns[key] - (blocked[key] || []))
      raise OutOfOptions if choices.length == 0
      result = choices[choices.length * rand]
      blocked[key] ||= []
      blocked[key] << result

      result.gsub(/\{[^\}]+\}/i) do |sub_expression|
        sub_expression = sub_expression[1..-2]
        if sub_expression.include?(",")
          sub_choices = sub_expression.split(",")
          sub_choice = sub_choices[sub_choices.length * rand]
          if @patterns[sub_choice]
            pick(sub_choice, blocked)
          else
            sub_choice
          end
        else
          if sub_expression =~ /^a\|(.*)$/i
            pick($1, blocked).en.a
          elsif sub_expression =~ /^c\|(.*)$/i
            pick($1, blocked).gsub(/^./) {|i| i.upcase}            
          elsif sub_expression =~ /^(.*?)\|s$/i
#            pick($1, blocked).gsub(/\w+$/) {|i| i.en.plural}
            pick($1, blocked).en.plural
          else
            pick(sub_expression, blocked)
          end
        end
      end
    rescue OutOfOptions
      raise OutOfOptionsRetry
    rescue OutOfOptionsRetry
      pick(key, blocked)
    end
  end
end

templates = <<-TEMPLATES
  RESULT        {Use,Leverage} the {API} to {BUILD_ACTION} {a|PRODUCT}.
  RESULT        {Combine,Mix,Mashup} the {API} with the {API} in {a|ADJECTIVE} {way,manner}.
  RESULT        Are {today's,existing,current,standard,enterprise} {PRODUCT|s} {OPTIMIZATION}?
  RESULT        What is a {problem,situation,type of problem} that could {be fixed,be made better} with the {API}?  {c|QUESTION_WORD} you could {BUILD_ACTION} {a|ADJECTIVE} {PRODUCT} with it?
  RESULT        {c|QUESTION_WORD} {an AdSense,a Yahoo! ads,a Microsoft ads} {arbitrage play,monitization scheme,monitization strategy} {USING} the {API}?
  RESULT        {c|QUESTION_WORD} {an AdSense,a Yahoo! ads,a Microsoft ads} {arbitrage play,monitization scheme,monitization strategy} {targeting,for,to be used by,primarily for,of interest to} the {INDUSTRY}?
  RESULT        {Link,Combine,Mashup,Unify} the {API} with {COMMUNICATION_TOOL} {somehow,in some way,for great justice}.
  RESULT        {Monitize,Make money from,Profit from} the {API} with {AD_TYPE|s}.
  RESULT        {What,Which tools,Which techniques,Are there any utilities that,Are there any tools that} would make {EXISTING_PRODUCT} {IMPROVEMENT}?
  RESULT        Apply the {API} or the {API} to {EXISTING_PRODUCT}.
  RESULT        {c|BUILD_ACTION} {ADJECTIVE} {AD_TYPE|s} for the {INDUSTRY}.
  RESULT        Make {COMMUNICATION_TOOL} more {engaging,enjoyable,easy to use,simple,easy} and {monitize,make money,profit} with {AD_TYPE|s}.
  RESULT        What {would,types of products would,software would,tools would} {help bring,aid in bringing,further bring,further extend} the {INDUSTRY} {online,more online,more on the web,into web 2.0}?
  RESULT        {Are there,Might there be,Could there be} {underserved,ignored,monitizable,needy} {subgroups,groups,people,niches,communities} in the {INDUSTRY}?
  RESULT        {c|QUESTION_WORD} {BUILD_ACTION} {a|PRODUCT} {for,targeting,designed for} the {INDUSTRY}?
  RESULT        {Have you seen,Have you considered,Do you know about,Are you aware of} the {API}?  {There are probably,There must be} {ADJECTIVE} {things,projects,utilities,tools,web apps} to be {made,built,created,constructed} {with,using} {this,that} {product,tool,utility,service}.
  RESULT        {c|EXISTING_PRODUCT} is a {very,super} {popular,large,big} {site,website,destination}.  {c|QUESTION_WORD} you {could,might} {BUILD_ACTION} {a niche,a vertical,an internationalized,a decentralized,an open-source,a white label} {version,clone,proxy,version} of it?
  RESULT        A {UTILITY} {which,that} {combines,aggregates,merges,meta-searches} {contests,recipies,health tips,tips,quizes,tv,movies,games,flash games,movie trailers,data,sports scores,stock data,finance info,user bank account info,funny pictures,blog posts} from {other sites,around the web,the web,web directories,multiple users,users,users' email,users' phones}.
  RESULT        A {UTILITY} {where,on which,with which} {users,people,friends,families,schools,organizations,businesses,non-profits,specific people,certain groups of people,groups of employees,coworkers,extended families,people in the same location,people in the same town,users of certain websites,webmasters} can {upload videos about,post thoughts on,describe their experiences with,bitch about,retell their experiences with,discuss,chat about} {their experiences,restaurants,bars,hotels,other websites,people,friends,coworkers,jobs,houses,their lives,vacations,parties,web services,blogs,EXISTING_PRODUCT}.
  UTILITY       {tool,utility,website,web destination}
  AD_TYPE       video ad
  AD_TYPE       contextual ad
  AD_TYPE       affilate link
  AD_TYPE       sponsored article
  AD_TYPE       audio ad
  ADJECTIVE     interesting
  ADJECTIVE     exciting
  USING         using
  USING         employing
  USING         leveraging
  QUESTION_WORD  perhaps
  QUESTION_WORD  maybe
  QUESTION_WORD  possibly
  IMPROVEMENT   better
  IMPROVEMENT   more efficient
  BUILD_ACTION  build
  BUILD_ACTION  make
  BUILD_ACTION  create
  BUILD_ACTION  develop
  PRODUCT       social networking site
  PRODUCT       communication {tool,utility}
  PRODUCT       business-oriented version of {COMMUNICATION_TOOL}
  PRODUCT       communication {utility,tool}
  PRODUCT       collaborative editing {utility,tool}
  PRODUCT       accounting {utility,tool}
  PRODUCT       bookkeeping {utility,tool}
  PRODUCT       visualization {utility,tool}
  PRODUCT       blog network
  PRODUCT       directory of {PRODUCT|s}
  OPTIMIZATION  fast enough
  OPTIMIZATION  easy enough to use
  OPTIMIZATION  sufficiently affordable
  OPTIMIZATION  sufficient for users' needs
  OPTIMIZATION  sufficiently advanced
  OPTIMIZATION  cheap enough
  OPTIMIZATION  priced appropriately enough
  OPTIMIZATION  appropriately entry level
  COMMUNICATION_TOOL  email
  COMMUNICATION_TOOL  instant messaging
  COMMUNICATION_TOOL  blogging
  COMMUNICATION_TOOL  Twitter
  COMMUNICATION_TOOL  Facebook
  COMMUNICATION_TOOL  Digg
  COMMUNICATION_TOOL  Google Wave
TEMPLATES

apis = File.read(File.join(File.dirname(__FILE__), 'APIs.txt'))
industries = File.read(File.join(File.dirname(__FILE__), 'industries.txt'))
existing_products = File.read(File.join(File.dirname(__FILE__), 'existing_products.txt'))
templates += [apis, industries, existing_products].join("\n")

picks = []
constructor = MadLib::Constructor.new(templates)
30.times do
  picks << constructor.pick('RESULT')
end
puts picks.uniq.join("\n")
