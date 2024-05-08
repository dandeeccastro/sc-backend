class Vacancy < ApplicationRecord
  validate :one_per_user
  validate :under_talk_limit

  belongs_to :user
  belongs_to :talk

  def one_per_user
    vacancies_by_same_user = Vacancy.all.find(user_id: user.id)
    vacancies_by_same_user.empty?
  end

  def under_talk_limit
    vacancies_by_talk = Vacancy.all.find(talk_id: talk.id)
    vacancies_by_talk.length < talk.vacancy_limit
  end
end
