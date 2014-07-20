#!/usr/bin/env ruby

require 'json'
require 'time'
require 'optparse'

# This hash will hold all the command-line options
options = {}

optparse = OptionParser.new do|opts|
    opts.banner = "Usage: parse-viewers.rb [-i inputfile] [-o outputfile]"

    options[:input] = File.expand_path("../../raw/chat", __FILE__)
    opts.on( '-i', '--input <file>', 'Read data from <file>' ) do |file|
        options[:input] = true
    end

    opts.on( '-h', '--help', 'Display this screen' ) do
        puts opts
        exit
    end
end

optparse.parse!

messages_per_minute = Hash.new(0)
word_frequency      = Hash.new(0)

File.open( options[:input] ).each do |line|
    if !line.start_with? '[' then
        next
     end

    *datestring, content = line.split(']', 3)
    time = Time.strptime datestring.join, "[%A, %B %d,  %Y [%H:%M:%S %p"

    re = /^\s*(?:\*|<)\s?(\w*)>?\s*(.*)$/
    match = content.match re

    if not match then
        next
    end

    author  = match[1]
    message = match[2]

    if author == 'zipkrowdbot' then
        # Nobody cares about the bot
        next
    end

    words = message.downcase.split(/[^a-zA-Z0-9\-_'"]+/).reject(&:empty?).select {|word| word.length > 3 }.each do
        |word| word_frequency[word] += 1
    end

    if words == nil then
        puts message
        puts words
    end

    messages_per_minute[time.utc.strftime "%D %R"] += 1
end

puts JSON.pretty_generate(word_frequency.sort_by {|k, v| [v, k] })
