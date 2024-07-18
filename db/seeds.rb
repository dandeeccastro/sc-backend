# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
event = Event.create(name: 'Semana da Computação', start_date: DateTime.now, end_date: 2.weeks.from_now, registration_start_date: DateTime.now)

locations = Location.create([
  { name: 'Roxinho' },
  { name: 'Eliana Audi' },
  { name: 'Sala 301' },
  { name: 'Auditório Eleanor' },
])

types = Type.create([
  { name: 'Minicurso', color: 'orange' },
  { name: 'Palestra', color: 'red' },
  { name: 'Workshop', color: 'blue' },
])

categories = Category.create([
  { name: 'IA', color: 'blue', event_id: event.id },
  { name: 'Ciência de Dados', color: 'red', event_id: event.id },
  { name: 'Hacking', color: 'green', event_id: event.id },
])

speakers = Speaker.create([
  { name: 'Dr C Mohan', bio: 'Um doutor muito importante', email: 'c.mohan@mohan', event: event },
  { name: 'Linus Torvalds', bio: 'Um desenvolvedor muito bom', email: 'linus.torvalds@linux.org', event: event },
  { name: 'Satoshi Nakamoto', bio: 'O cara que criou bitcoin', email: 'satoshi@anon.com', event: event },
])

Talk.create([
  { 
    title: 'Desvendando Blockchain',
    description: 'Blockchain é algo muito complicado. Vamos entender?',
    start_date: DateTime.now,
    end_date: 1.hour.from_now,
    vacancy_limit: 50,
    event: event,
    location: locations.first,
    speaker: speakers.first,
    type: types.first,
    categories: [categories.first],
  },
  { 
    title: 'Game Jam com a GDP',
    description: 'Vamos aprender game dev!',
    start_date: 1.hour.from_now,
    end_date: 2.hours.from_now,
    vacancy_limit: 50,
    event: event,
    location: locations.first,
    speaker: speakers.first,
    type: types.first,
    categories: [categories.first],
  },
  { 
    title: 'Desenvolvimento web é fácil',
    description: 'Disse ninguém, nunca',
    start_date: 2.hours.from_now,
    end_date: 3.hours.from_now,
    vacancy_limit: 50,
    event: event,
    location: locations.first,
    speaker: speakers.first,
    type: types.first,
    categories: [categories.first],
  },
])
