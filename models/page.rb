require 'gyazz'

class Page
  include Mongoid::Document
  field :gyazz_name, :type => String, :default => ''
  field :page_name, :type => String, :default => ''
  field :lines, :type => Array, :default => Array.new
  field :last_modified_at, :type => Time, :default => lambda{ Time.now }
  field :created_at, :type => Time, :default => lambda{ Time.now }

  def diff(lines)
    lines.delete_if{|line|
      self.lines.include? line
    }.uniq
  end

  def self.find_by_names(gyazz_name, page_name)
    where(:gyazz_name => gyazz_name, :page_name => page_name).first
  end
end
