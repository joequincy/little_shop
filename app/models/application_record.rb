class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  module ChartSupport
    def to_pie_columns(data)
      self.map do |record|
        {name: record[data.keys.first], data: record[data.values.first]}
      end
    end

    def to_timeseries(date, value)
      x = ['dates']
      y = ['values']
      self.each do |record|
        x << record[date].strftime("%Y-%m-%d")
        y << record[value].to_f.round(2)
      end
      return x, y
    end
  end
  ActiveRecord::AssociationRelation.send(:include, ApplicationRecord::ChartSupport)
  ActiveRecord::Relation.send(:include, ApplicationRecord::ChartSupport)
end
