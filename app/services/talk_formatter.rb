class TalkFormatter
  def self.format_talks_into_schedule(talks)
    dates = Hash[talks.map(&:day).uniq.collect{ |v| [v, []] }]
    talks.each { |talk| dates[talk.day] << talk }
    dates.map { |date, talks| dates[date] = TalkBlueprint.render_as_hash(talks) }
    dates
  end

  def self.format_vacancies_into_schedule(vacancies)
    talks = vacancies.map(&:talk)
    format_talks_into_schedule(talks)
  end
end
