class Rating < ApplicationRecord
  validate :score_in_range
  validate :user_participated_in_talk
  validate :not_scored_yet

  belongs_to :user
  belongs_to :talk

  def user_participated_in_talk
    vacancy = Vacancy.where('user_id = :user_id AND talk_id = :talk_id AND presence = true', { user_id: user_id, talk_id: talk_id })
    errors.add(:cant_rate, 'Usuário não assistiu a atividade!') if vacancy.empty?
  end

  def score_in_range
    errors.add(:invalid_score, 'Nota deve ser entre 1 e 5!') if score > 5 || score < 1
  end

  def not_scored_yet
    ratings = Rating.where('user_id = :user_id AND talk_id = :talk_id AND id != :id', { user_id: user_id, talk_id: talk_id, id: id })
    errors.add(:already_scored, 'Usuário já avaliou a atividade!') unless ratings.empty?
  end
end
