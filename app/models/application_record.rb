# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  connects_to database: { writing: Rails.env.to_sym, reading: Rails.env.to_sym }
end
