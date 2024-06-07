class Vacancy < ApplicationRecord
  validate :one_per_user
  validate :under_talk_limit

  belongs_to :user
  belongs_to :talk

  def one_per_user
    vacancies_by_same_user = Vacancy.where('user_id = :user_id AND id != :id', { user_id: user_id, id: id })
    errors.add(:multiple_vacancies, 'Você já tem reserva nessa palestra!') unless vacancies_by_same_user.empty?
  end

  def under_talk_limit
    vacancies_by_talk = Vacancy.where('talk_id = :talk_id AND id != :id', { talk_id: talk_id, id: id })
    errors.add(:full, 'Essa palestra já está cheia!') unless vacancies_by_talk.length < talk.vacancy_limit
  end
end
