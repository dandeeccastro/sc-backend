class Vacancy < ApplicationRecord
  belongs_to :user
  belongs_to :talk
end
