# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
User.create(
  name: 'Administrador',
  email: 'admin@ic.ufrj.br',
  password: 'senha123',
  permissions: User::ADMIN,
  cpf: '316.643.966-83',
)

events = Event.create([
  {
    name: 'Semana da Computação',
    start_date: DateTime.now,
    end_date: 2.weeks.from_now,
    registration_start_date: DateTime.now
  },
  {
    name: 'SIAC 3a Edição',
    start_date: DateTime.now,
    end_date: 1.month.from_now,
    registration_start_date: DateTime.now
  },
  {
    name: 'Semana da Química',
    start_date: DateTime.now,
    end_date: 1.week.from_now,
    registration_start_date: DateTime.now
  },
])

locations = Location.create([
  { name: 'Roxinho' },
  { name: 'Eliana Audi' },
  { name: 'Sala 301' },
  { name: 'Auditório Eleanor' },
])

types = Type.create([
  { name: 'Palestra', color: 'red' },
  { name: 'Minicurso', color: 'orange' },
  { name: 'Workshop', color: 'blue' },
])

categories = Category.create([
  { name: 'Blockchain', color: 'green', event_id: events.first.id },
  { name: 'IA', color: 'blue', event_id: events.first.id },
  { name: 'Ciência de Dados', color: 'red', event_id: events.first.id },

  { name: 'Ciência da Computação', color: 'blue', event_id: events.second.id },
  { name: 'Matemática', color: 'red', event_id: events.second.id },
  { name: 'Física Quântica', color: 'green', event_id: events.second.id },

  { name: 'Composto simples', color: 'blue', event_id: events.third.id },
  { name: 'Bioquimica', color: 'red', event_id: events.third.id },
])

speakers = Speaker.create([
  { name: 'Dr C Mohan', bio: 'Especialista em criptomoedas e smart contracts, Dr C. Mohan é conhecido por sua contribuição para o Ethereum.', email: 'c.mohan@mohan', event: event.first },
  { name: 'SmartThis', bio: 'Empresa de tecnologia especializada na área de RPA.', email: 'smartthis@gmail.com', event: event.first },
  { name: 'Bradesco', bio: 'Banco que passou por uma transformação digital e vem para o evento contar sua trajetória de renovação!', email: 'bra@des.co', event: event.first },

  { name: 'GDP', bio: 'Grupo de desenvolvimento de jogos da UFRJ', email: 'gdp@ufrj.br', event: event.second },
  { name: 'GRIS', bio: 'Grupo de segurança da informação da UFRJ', email: 'gris@ufrj.br', event: event.second },

  { name: 'João Carlos', bio: 'Pesquisador de química', email: 'joao.carlos@ufrj.br', event: event.third },
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
