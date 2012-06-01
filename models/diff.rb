class Diff
  include Mongoid::Document
  field :gyazz_name, :type => String, :default => ''
  field :page_name, :type => String, :default => ''
  field :lines, :type => Array, :default => Array.new
  field :created_at, :type => Time, :default => lambda{ Time.now }
end
