module Definitions::Player
  extend ActiveSupport::Concern
  included do

    api_accessible :basic do |t|
      t.add :id
      t.add :firstname
      t.add :lastname
    end

    api_accessible :expanded, :extend => :basic do |t|
      t.add :email
      t.add :name
      t.add :club
      t.add :as_day, as: :date_of_birth
      t.add :position
    end

    def as_day
      if date_of_birth.present?
        return date_of_birth.to_date.iso8601
      end
      return nil
    end
  end
end