#!/usr/bin/env ruby
require 'rubygems'
require 'linguistics'
Linguistics::use( :en )

module IdeaMachine
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

    def generate(num=1)
      out = []
      num.times do
        out << pick('RESULT').strip.squeeze(" ").gsub(/\s+([\?\!\.\,])/, '\1')
      end
      out
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
          if sub_expression =~ /^(a)\|(.*)$/i
            if ($1 == 'A')
              pick($2, blocked).en.a.gsub(/^./) {|i| i.upcase}
            else
              pick($2, blocked).en.a
            end
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
