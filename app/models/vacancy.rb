class Vacancy < ApplicationRecord
  validate :under_talk_limit

  validates_uniqueness_of :user_id, scope: [:talk_id]

  belongs_to :user
  belongs_to :talk

  def under_talk_limit
    vacancies_by_talk = Vacancy.where('talk_id = :talk_id AND id != :id', { talk_id: talk_id, id: id })
    errors.add(:full, 'Essa atividade já está cheia!') unless vacancies_by_talk.length < talk.vacancy_limit
  end
end
