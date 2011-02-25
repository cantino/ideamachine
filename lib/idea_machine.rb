#!/usr/bin/env ruby
require 'rubygems'
require 'linguistics'
Linguistics::use( :en )

module IdeaMachine
  class OutOfOptions < RuntimeError; end
  class OutOfOptionsRetry < RuntimeError; end

  class Constructor
    attr_accessor :options

    def initialize(templates, options = {})
      if templates.is_a?(String)
        init_from_string(templates)
      else
        @patterns = templates
      end
      @options = options
    end

    def init_from_string(templates)
      @patterns = {}
      templates.each_line do |line|
        next if line.strip =~ /^#|^\s*$/
        if line.strip =~ /^([\w\_\d]+)\s+(.*)$/i
          @patterns[$1] ||= []
          @patterns[$1] << $2
        else
          puts "I don't understand: #{line}"
        end
      end
    end

    def generate(num=1, force_index = nil)
      out = []
      num.times do
        begin
          out << pick('RESULT', {}, force_index).strip.gsub('NULL', '').gsub(/\s+/, ' ').gsub(/\s+([\?\!\.\,])/, '\1')
        rescue OutOfOptionsRetry
          puts "WARNING: Got OutOfOptionsRetry"
        end
      end
      out
    end

    def pick(key, blocked = {}, force_index = nil)
      raise "Cannot find key #{key}" unless @patterns[key]
      choices = (@patterns[key] - (blocked[key] || []))
      raise OutOfOptions if choices.length == 0
      result = if force_index
        choices[force_index]
      else
        choices[choices.length * rand]
      end
      blocked[key] ||= []
      blocked[key] << result if options[:disallow_duplicates]

      puts "#{key}: #{result}" if options[:debug]

      return_value = result.gsub(/\{[^\}]+\}/i) do |sub_expression|
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
            pick($1, blocked).en.plural
          else
            pick(sub_expression, blocked)
          end
        end
      end
      puts "Returning: #{return_value}" if options[:debug]
      return_value
    rescue OutOfOptionsRetry
      pick(key, blocked)
    rescue OutOfOptions
      raise OutOfOptionsRetry
    end
  end
end
