#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
require 'gyazz'
require 'args_parser'
require File.dirname(__FILE__)+'/../bootstrap'
Bootstrap.init :inits, :models

parser = ArgsParser.parse ARGV do
  arg :interval, 'loop interval (sec)', :default => 3
  arg :limit, 'number of page to check', :default => 30
  arg :help, 'show help', :alias => :h
end

if parser.has_option? :help
  puts parser.help
  exit 1
end

Conf['gyazz'].each do |g|
  gyazz_name = g['name']
  gyazz = Gyazz.new(gyazz_name, g['user'], g['pass'])
  list = gyazz.list[0...parser[:limit].to_i]
  list.each_with_index do |page_name, i|
    url = "http://gyazz.com/#{gyazz_name}/#{page_name}"
    puts "check(#{i+1}/#{list.size}) : #{url}"
    begin
      lines = gyazz.get(page_name).split(/[\r\n]/).delete_if{|i| i.size < 1 }
      unless page = Page.find_last_one_by_names(gyazz_name, page_name)
        puts " => newpage"
        page = Page.new(:page_name => page_name,
                        :gyazz_name => gyazz_name,
                        :lines => lines)
        page.save
      else
        diff = page.diff lines
        if diff.size > 0
          puts " => #{diff.size} lines changed"
          diff.each do |d|
            puts " diff : #{d}"
          end
          page = Page.new(:page_name => page_name,
                          :gyazz_name => gyazz_name,
                          :lines => lines)
          page.save
        end
      end
    rescue StandardError, Timeout::Error => e
      STDERR.puts "error : #{url}"
      STDERR.puts e
    end
    sleep parser[:interval].to_i
  end
end
