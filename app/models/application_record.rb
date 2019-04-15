class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  module ChartSupport
    def to_pie_columns(data)
      self.map do |record|
        {name: record[data.keys.first], data: record[data.values.first]}
      end
    end
  end
  ActiveRecord::AssociationRelation.send(:include, ApplicationRecord::ChartSupport)
end
