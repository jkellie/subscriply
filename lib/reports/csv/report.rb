require 'csv'

class Reports::CSV::Report
  DEFAULT_OPTIONS = {return_enumberable: false}

  def initialize(query, options={})
    @options = DEFAULT_OPTIONS.merge(options)
    @query = query
  end

  def columns
  end

  def row(object)
    columns.map { |c| object.send(c) }
  end

  def to_csv
    ::CSV.generate(encoding: 'utf-8') do |line|
      line << columns
      @query.each do |obj|
        line << row(obj)
      end
    end    
  end

  def self.to_csv(query, options={})
    new(query, options).to_csv
  end
end