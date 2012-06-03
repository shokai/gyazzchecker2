#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
require 'args_parser'
require File.dirname(__FILE__)+'/../bootstrap'
Bootstrap.init :inits, :models

parser = ArgsParser.parse ARGV do
  arg :time, 'range of Time (sec)', :default => 60*60
  arg :help, 'show help', :alias => :h
end

if parser.has_option? :help
  puts parser.help
  puts "e.g.  ruby #{$0} -time 3600"
  exit 1
end

pages = Page.find_by_created_at(Time.now, Time.now-parser[:time].to_i)

pages.map{|page|
  [page.gyazz_name, page.page_name]
}.uniq.each do |names|
  tmp = pages.find_by_names(names[0], names[1])
  a = tmp.first
  b = tmp.size > 1 ? tmp.last :
    Page.find_by_names(a.gyazz_name, a.page_name).
    find_by_created_at(Time.now-parser[:time].to_i, Time.at(0)).first
  unless b
    puts "newpage : #{a.url}"
  else
    diff = b.diff a
    if diff.size > 0
      puts "#{diff.size} lines and #{tmp.size} changes : #{a.url}"
    end
  end
end
