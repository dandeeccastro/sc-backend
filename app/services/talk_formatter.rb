class TalkFormatter
  def self.format_talks_into_schedule(talks)
    dates = Hash[talks.map(&:day).uniq.collect{ |v| [v, []] }]
    talks.each { |talk| dates[talk.day] << talk }
    dates.map { |date, talks| dates[date] = TalkBlueprint.render_as_hash(talks) }
    dates
  end

  def self.format_vacancies_into_schedule(vacancies)
    dates = Hash[vacancies.map{|v| v.talk.day }.uniq.collect{ |v| [v, []] }]
    vacancies.each { |vacancy| dates[vacancy.talk.day] << vacancy }
    dates.map { |date, vacancies| dates[date] = VacancyBlueprint.render_as_hash(vacancies) }
    dates
  end
end
