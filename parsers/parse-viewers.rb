#!/usr/bin/env ruby
# A script that will pretend to resize a number of images

require 'json'
require 'optparse'

# This hash will hold all the command-line options
options = {}

optparse = OptionParser.new do|opts|
    opts.banner = "Usage: parse-viewers.rb [-i inputfile] [-o outputfile]"

    options[:input] = File.expand_path("../../raw/viewers", __FILE__)
    opts.on( '-i', '--input <file>', 'Read date from <file>' ) do |file|
        options[:input] = true
    end

    options[:output] = File.expand_path("../../data/viewers", __FILE__)
    opts.on( '-o', '--output <file>', 'Output JSON data to <file>' ) do |file|
        options[:output] = file
    end

    opts.on( '-h', '--help', 'Display this screen' ) do
        puts opts
        exit
    end
end

optparse.parse!

viewers = []

File.open( options[:input] ).each do |line|
    viewers.push({
        date: line.rpartition(' ').first,
        count: line.rpartition(' ').last
    })
end

File.open( options[:output], 'w' ) do |file|
    file.puts JSON.generate counts: viewers
end
