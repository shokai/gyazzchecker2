require 'gyazz'

class Page
  include Mongoid::Document
  field :gyazz_name, :type => String, :default => ''
  field :page_name, :type => String, :default => ''
  field :lines, :type => Array, :default => Array.new
  field :created_at, :type => Time, :default => lambda{ Time.now }

  def diff(lines)
    arr = Array.new
    lines.each do |line|
      arr.push line unless self.lines.include? line
    end
    arr.uniq
  end

  def self.find_last_one_by_names(gyazz_name, page_name)
    where(:gyazz_name => gyazz_name,
          :page_name => page_name).
      desc(:created_at).first
  end
end
