require 'gyazz'

class Page
  include Mongoid::Document
  field :gyazz_name, :type => String, :default => ''
  field :page_name, :type => String, :default => ''
  field :lines, :type => Array, :default => Array.new
  field :created_at, :type => Time, :default => lambda{ Time.now }

  def diff(lines)
    lines = lines.lines if lines.kind_of? self.class
    arr = Array.new
    lines.each do |line|
      arr.push line unless self.lines.include? line
    end
    arr.uniq
  end

  def url
    "http://gyazz.com/#{gyazz_name}/#{page_name}"
  end

  def self.find_by_names(gyazz_name, page_name)
    where(:gyazz_name => gyazz_name,
          :page_name => page_name)
  end

  def self.find_last_one_by_names(gyazz_name, page_name)
    find_by_names(gyazz_name, page_name).desc(:created_at).first
  end

  def self.find_by_created_at(time_a, time_b)
    res = where(:created_at.lt => time_a, :created_at.gt => time_b)
    time_a > time_b ? res.desc(:created_at) : res.asc(:created_at)
  end
end
