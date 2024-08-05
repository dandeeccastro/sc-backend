# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
users = User.create([
  {
    name: 'Administrador',
    email: 'admin@ic.ufrj.br',
    password: 'senha123',
    permissions: User::ADMIN,
    cpf: '316.643.966-83',
  },
  {
    name: 'Lider de equipe',
    email: 'lider@ic.ufrj.br',
    password: 'senha123',
    permissions: User::STAFF_LEADER,
    cpf: '162.519.663-60',
  },
  {
    name: 'Membro de equipe',
    email: 'membro@ic.ufrj.br',
    password: 'senha123',
    permissions: User::STAFF,
    cpf: '932.212.519-55',
  },
  {
    name: 'Danilo Collares',
    email: 'danilo@c.castro',
    password: 'senha123',
    permissions: User::ATTENDEE,
    cpf: '317.691.815-12'
  },
  {
    name: 'Stephanie Orazem',
    email: 'sorazem@alternex.com',
    password: 'senha123',
    permissions: User::ATTENDEE,
    cpf: '944.728.544-90',
  }
])

events = Event.create([
  {
    name: 'Semana da Computação',
    start_date: DateTime.current.change(hour: 01),
    end_date: 2.weeks.from_now,
    registration_start_date: DateTime.now
  },
  {
    name: '1a Semana das Licenciaturas da EBA',
    start_date: DateTime.current.change(hour: 01),
    end_date: 3.days.from_now,
    registration_start_date: DateTime.now
  },
  {
    name: 'Semana da Química - 30ª edição',
    start_date: DateTime.current.change(hour: 01),
    end_date: 1.day.from_now,
    registration_start_date: DateTime.now
  },
])

Merch.create([
  {
    name: 'Caneca da Semana da Computação',
    price: 1200,
    stock: 50,
    custom_fields: nil,
    event: events.first,
  },
])

Notification.create([
  {
    title: 'Semana da Computação chegou! 🥳',
    description: 'Depois de muita espera e ansiedade, estamos orgulhosos de afirmar que a Semana da Computação está com as inscrições abertas!',
    event: events.first,
    user: users.second,
  },
])

events.first.team.update(users: [users.second, users.third])

locations = Location.create([
  { name: 'Roxinho' },
  { name: 'Eliana Audi' },
  { name: 'Sala 301' },
  { name: 'Auditório Salão Nobre' },
  { name: 'Sala 619' },
  { name: 'Sala 626A' },
  { name: 'Sala 715' },
  { name: 'Sala 711' },
  { name: 'Sala 713' },
  { name: 'Sala 707' },
  { name: 'Hall do Prédio' },
])

types = Type.create([
  { name: 'Palestra', color: 'red' },
  { name: 'Minicurso', color: 'orange' },
  { name: 'Oficina', color: 'blue' },

  { name: 'Mesa de Abertura', color: '#009933' },
  { name: 'Mesa', color: '#009966' },
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
  { name: 'Dr C Mohan', bio: 'Especialista em criptomoedas e smart contracts, Dr C. Mohan é conhecido por sua contribuição para o Ethereum.', email: 'c.mohan@mohan', event: events.first },
  { name: 'SmartThis', bio: 'Empresa de tecnologia especializada na área de RPA.', email: 'smartthis@gmail.com', event: events.first },
  { name: 'Bradesco', bio: 'Banco que passou por uma transformação digital e vem para o evento contar sua trajetória de renovação!', email: 'bra@des.co', event: events.first },
  { name: 'Danilo Collares', bio: 'Aluno da UFRJ, desenvolvedor da plataforma Venti e entusiasta de tecnologias obscuras!', email: 'danilo@collares.de.castro', event: events.first },

  { name: 'Wilson Cardoso', bio: '', event: events.second },
  { name: 'Marina Menezes', bio: '', event: events.second },
  { name: 'Heloisa Vieira', bio: '', event: events.second },
  { name: 'Ana Clara Ceia', bio: '', event: events.second },
  { name: 'Gabriel Nogueira', bio: '', event: events.second },
  { name: 'Leonora Braga', bio: '', event: events.second },
  { name: 'Isabella Lima', bio: '', event: events.second },
  { name: 'Willian Ferreira', bio: '', event: events.second },
  { name: 'Manuela Pontes', bio: '', event: events.second },
  { name: 'Felipe Antunes', bio: '', event: events.second },
  { name: 'Gustavo Monteiro', bio: '', event: events.second },
  { name: 'Clara Sabino', bio: '', event: events.second },
  { name: 'Luís Felipe da Silva', bio: '', event: events.second },
  { name: 'Ana Beatriz Teixeira', bio: '', event: events.second },
  { name: 'May Braga', bio: '', event: events.second },
  { name: 'Alexandre Palma', bio: '', event: events.second },
  { name: 'Malu Rangel', bio: '', event: events.second },
  { name: 'Stefany', bio: '', event: events.second },
  { name: 'Stella Feitosa', bio: '', event: events.second },
  { name: 'Jessica Silva', bio: '', event: events.second },
  { name: 'Adnayara Feitosa', bio: '', event: events.second },
  { name: 'Manoel Pedro', bio: '', event: events.second },
  { name: 'Danusa Chini Gani', bio: '', event: events.second },
  { name: 'Flávia Adriano', bio: '', event: events.second },
  { name: 'Maju Ferreira', bio: '', event: events.second },
  { name: 'Andrea Penteado', bio: '', event: events.second },
  { name: 'Doralice Duque', bio: '', event: events.second },
  { name: 'Gabrielle Carvalho', bio: '', event: events.second },
  { name: 'Jorge Marcelo Alvez', bio: '', event: events.second },

  { name: 'João Carlos', bio: 'Pesquisador de química', email: 'joao.carlos@ufrj.br', event: events.third },
])

Talk.create([
  { 
    title: 'Desvendando Blockchain',
    description: 'Blockchain é algo muito complicado. Vamos entender?',
    start_date: DateTime.now,
    end_date: 1.hour.from_now,
    vacancy_limit: 50,
    event: events.first,
    location: locations.first,
    speakers: [speakers.first],
    type: types.first,
    categories: [categories.first],
  },
  { 
    title: 'Game Jam com a GDP',
    description: 'Vamos aprender game dev!',
    start_date: 1.hour.from_now,
    end_date: 2.hours.from_now,
    vacancy_limit: 50,
    event: events.first,
    location: locations.first,
    speakers: [speakers.first],
    type: types.first,
    categories: [categories.first],
  },
  { 
    title: 'Desenvolvimento web é fácil',
    description: 'Disse ninguém, nunca',
    start_date: 2.hours.from_now,
    end_date: 3.hours.from_now,
    vacancy_limit: 50,
    event: events.first,
    location: locations.first,
    speakers: [speakers.first],
    type: types.first,
    categories: [categories.first],
  },

  {
    title: 'Desafios para a Educação Inclusiva na formação da docência em Artes Visuais e Expressão Gráfica',
    description: 'Participação de Maria Clara Machado, Marcelo Cucco, Leila Gross e Rodolfo Tavares',
    start_date: DateTime.current.change(hour: 9),
    end_date: DateTime.current.change(hour: 11),
    vacancy_limit: 50,
    location: Location.find_or_create_by(name: 'Auditório Salão Nobre'),
    type: Type.find_or_create_by(name: 'Mesa'),
    speakers: [Speaker.find_or_create_by(name: 'Wilson Cardoso')],
    event: events.second,
  },
  {
    start_date: DateTime.current.change(hour: 13, minute: 30),
    end_date: DateTime.current.change(hour: 14, minute: 45),
    vacancy_limit: 50,
    location: Location.find_or_create_by(name: 'Auditório Salão Nobre'),
    type: Type.find_or_create_by(name: 'Mesa'),
    title: 'Experiências na Educação Museal, ensino de artes e produção cultural',
    description: 'Participação de Roberta Condeixa, Rebeca Belmont, Renata Sampaio e Patricia Marys',
    speakers: [Speaker.find_or_create_by(name: 'Marina Menezes')],
    event: events.second,
  },
  {
    start_date: DateTime.current.change(hour: 15),
    end_date: DateTime.current.change(hour: 16),
    vacancy_limit: 50,
    location: Location.find_or_create_by(name: 'Sala 619'),
    type: Type.find_or_create_by(name: 'Oficina'),
    title: 'Colagem',
    description: '',
    speakers: [Speaker.find_or_create_by(name: 'Heloísa Vieira')],
    event: events.second,
  },
  {
    start_date: DateTime.current.change(hour: 15),
    end_date: DateTime.current.change(hour: 16),
    vacancy_limit: 50,
    location: Location.find_or_create_by(name: 'Sala 626A'),
    type: Type.find_or_create_by(name: 'Oficina'),
    title: 'Anamorfose',
    description: '',
    speakers: [Speaker.find_or_create_by(name: 'Gabriel Nogueira')],
    event: events.second,
  },
  {
    start_date: 1.day.from_now.change(hour: 9),
    end_date: 1.day.from_now.change(hour: 10, minute: 30),
    vacancy_limit: 50,
    location: Location.find_or_create_by(name: 'Auditório Salão Nobre'),
    type: Type.find_or_create_by(name: 'Mesa'),
    title: 'Saberes e fazeres na formação para a docência de Artes Visuais e Expressão Gráfica na educação formal e não forma',
    description: 'Participação de Jorge Paulino, Marcelo Bueno, Cristina Pierre, Sandra Barata e Mariana Maia', speakers: [Speaker.find_or_create_by(name: 'Alexandre Palma')],
    event: events.second,
  },
  {
    start_date: 1.day.from_now.change(hour: 11),
    end_date: 1.day.from_now.change(hour: 12),
    vacancy_limit: 50,
    location: Location.find_or_create_by(name: 'Sala 715'),
    type: Type.find_or_create_by(name: 'Oficina'),
    title: 'Design de Personagens',
    description:'',
    speakers: [Speaker.find_or_create_by(name: 'Malu Rangel')],
    event: events.second,
  },
  {
    start_date: 1.day.from_now.change(hour: 11),
    end_date: 1.day.from_now.change(hour: 12),
    vacancy_limit: 50,
    location: Location.find_or_create_by(name: 'Sala 711'),
    type: Type.find_or_create_by(name: 'Oficina'),
    title: 'Encadernação Artesanal',
    description:'',
    speakers: [Speaker.find_or_create_by(name: 'Stella Feitosa')],
    event: events.second,
  },
  {
    start_date: 1.day.from_now.change(hour: 11),
    end_date: 1.day.from_now.change(hour: 12),
    vacancy_limit: 50,
    location: Location.find_or_create_by(name: 'Sala 713'),
    type: Type.find_or_create_by(name: 'Oficina'),
    title: 'Padrões na madeira: entendendo a impressão em blocos indianos',
    description:'',
    speakers: [Speaker.find_or_create_by(name: 'Manoel Pedro')],
    event: events.second,
  },
  {
    start_date: 1.day.from_now.change(hour: 13, minute: 30),
    end_date: 1.day.from_now.change(hour: 14, minute: 30),
    vacancy_limit: 50,
    location: Location.find_or_create_by(name: 'Auditório Salão Nobre'),
    type: Type.find_or_create_by(name: 'Mesa'),
    title: 'A reforma curricular das licenciaturas da Escola de Belas Artes da UFRJ',
    description: 'Participação de Anita Delmas, Doralice Duque e Mariane Brito',
    speakers: [Speaker.find_or_create_by(name: 'Danusa Chini Gani')],
    event: events.second,
  },
  {
    start_date: 1.day.from_now.change(hour: 15),
    end_date: 1.day.from_now.change(hour: 16),
    vacancy_limit: 50,
    location: Location.find_or_create_by(name: 'Sala 707'),
    type: Type.find_or_create_by(name: 'Oficina'),
    title: 'Quantos desenhos cabem em 1 segundo? - Uma provocação em rotoscopia',
    description:'',
    speakers: [Speaker.find_or_create_by(name: 'Flávia Adriano')],
    event: events.second,
  },
  {
    start_date: 1.day.from_now.change(hour: 15),
    end_date: 1.day.from_now.change(hour: 16),
    vacancy_limit: 50,
    location: Location.find_or_create_by(name: 'Sala 713'),
    type: Type.find_or_create_by(name: 'Oficina'),
    title: 'Arte, moda e comportamento',
    description: '',
    speakers: [Speaker.find_or_create_by(name: 'Mateus Santos')],
    event: events.second,
  },
  {
    start_date: 2.days.from_now.change(hour: 9),
    end_date: 2.days.from_now.change(hour: 10, minute: 15),
    vacancy_limit: 50,
    location: Location.find_or_create_by(name: 'Auditório Salão Nobre'),
    type: Type.find_or_create_by(name: 'Mesa'),
    title: 'Trajetórias profissionais e a formação de identidades docentes',
    description: 'Participação de Marilane Abreu, Thais Spínola, David Francisco e André Queiroz',
    speakers: [Speaker.find_or_create_by(name: 'Andrea Penteado')],
    event: events.second,
  },
  {
    start_date: 2.days.from_now.change(hour: 10, minute: 30), end_date: 2.days.from_now.change(hour: 12), vacancy_limit: 50,
    location: Location.find_or_create_by(name: 'Auditório Salão Nobre'),
    type: Type.find_or_create_by(name: 'Mesa'),
    title: 'PIBID UFRJ - Formação inicial e pesquisa docente',
    description: 'Participação de Rejane Amorim, Celso Ramalho, Tatiane Silvana, Renata Vellozo e Evelyn Lavor',
    speakers: [Speaker.find_or_create_by(name: 'Doralice Duque')],
    event: events.second,
  },
  {
    start_date: 2.days.from_now.change(hour: 13, minute: 30),
    end_date: 2.days.from_now.change(hour: 14, minute: 45),
    vacancy_limit: 50,
    location: Location.find_or_create_by(name: 'Auditório Salão Nobre'),
    type: Type.find_or_create_by(name: 'Mesa'),
    title: 'Formação Continuada e Pesquisa no campo das Artes Visuais e Expressão Gráfica',
    description: 'Palestra de encerramento com participação de Maria Cristina Miranda e Maria Helena Wyllie',
    speakers: [Speaker.find_or_create_by(name: 'Gabrielle Carvalho e Jorge Marcelo Alves')],
    event: events.second,
  },

  {
    start_date: DateTime.current.change(hour: 11),
    end_date: DateTime.current.change(hour: 12),
    vacancy_limit: 50,
    location: Location.find_or_create_by(name: 'Auditório - CT - Bloco A - UFRJ'),
    type: Type.find_or_create_by(name: 'Mesa'),
    title: 'INTELIGÊNCIA ARTIFICIAL APLICADA NA QUÍMICA (MESA DE ABERTURA)',
    description: 'O uso da inteligência artificial em diversos ramos da sociedade vem sendo um tema polêmico. Por um lado, as várias vantagens obtidas a partir de sua aplicação destacam-se como pontos positivos, no entanto, o surgimento de questões atreladas aos direitos humanos preocupa como consequência do avanço desta área. Com isso, esta mesa de abertura trará percepções de como a inteligência artificial é aplicada na química atualmente e quais são suas perspectivas futuras, considerando tanto os benefícios quanto os possíveis malefícios advindos dessa revolução tecnológica.',
    speakers: [Speaker.find_or_create_by(name: 'Dr. Pierre Mothé Esteves', event: events.third)],
    event: events.third,
  },
  {

    start_date: DateTime.current.change(hour: 11),
    end_date: DateTime.current.change(hour: 12),
    vacancy_limit: 50,
    location: Location.find_or_create_by(name: 'Sala 633 - Instituto de Química - UFRJ'),
    type: Type.find_or_create_by(name: 'Palestra'),
    title: 'A ESPECTROMETRIA DE MASSAS NO DESENVOLVIMENTO DE BIOFÁRMACOS',
    description: 'O setor de biofármacos está no topo de uma era transformadora da indústria farmacêutica. Esta classe de medicamentos têm demonstrado altíssima eficácia no tratamento de diversas doenças complexas, como tumorais e neoplasias de diversos graus, trazendo como benefício a redução de efeitos colaterais. Estima-se que os biofármacos podem se tornar o núcleo da indústria farmacêutica em poucos anos. O processo de desenvolvimento e fabricação destes medicamentos é uma jornada desafiadora, que exige alto nível de investimento em tecnologias analíticas capazes de caracterizar estas big moléculas. Neste contexto, a Espectrometria de Massas desempenha um papel vital nesta jornada, fornecendo insights detalhados sobre as estruturas das proteínas, controle de qualidade, desenvolvimento de biossimilares, farmacocinética e monitoramento de processos. Sua alta sensibilidade, especificidade e capacidade de manipular amostras complexas a tornam indispensável na indústria biofarmacêutica.',
    speakers: [Speaker.find_or_create_by(name: 'Dra. Caroline Jaegger', event: events.third)],
    event: events.third,
  },
  {
    start_date: DateTime.current.change(hour: 8, minute: 30),
    end_date: 1.day.from_now.change(hour: 11),
    vacancy_limit: 50,
    location: Location.find_or_create_by(name: 'Auditório - Centro de Tecnologia - Bloco A - UFRJ'),
    type: Type.find_or_create_by(name: 'Curso', color: '#ff0066'),
    title: 'CONHECENDO A QUÍMICA FORENSE: O CSI DA VIDA REAL',
    description: 'A química forense é o ramo das ciências forenses voltado para a produção de provas materiais para a justiça, através de análise de substâncias em matrizes diversas, tais como drogas lícitas e ilícitas, venenos, acelerantes e resíduos de incêndio, explosivos, resíduos de disparo de armas de fogo, combustíveis, tintas, fibras, dentre outros. Embora a química forense seja um tema muito importante e que desperte cada vez mais interesse perante a sociedade científica, a sua aplicação no campo da criminalística ainda constitui uma nova linha de pesquisa no Brasil. Desta forma, o curso tem como objetivo apresentar os principais conceitos relacionados a Química Forense em três grandes áreas: balística, documentoscopia e drogas de abuso, e como a Química pode auxiliar na resolução de crimes, o funcionamento do IML (Instituto Médico Legal) e dar o suporte analítico necessário nesta área. Para ilustrar as aplicações da Química Forense, o curso também contará com a participação de um perito legista toxicologista da Secretaria de Polícia Civil do Estado do Rio de Janeiro e Diretor do Centro de Estudos e Pesquisas Forenses, que apresentará um poco da sua vivência no dia a dia da rotina de trabalho.',
    speakers: [Speaker.find_or_create_by(name: 'Dra. Ananda da Silva Antonio', event: events.third)],
    event: events.third,
  },
  {
    start_date: DateTime.current.change(hour: 8),
    end_date: DateTime.current.change(hour: 12),
    vacancy_limit: 50,
    location: Location.find_or_create_by(name: 'Sala 633 - Instituto de Química - UFRJ'),
    type: Type.find_or_create_by(name: 'Cozinha'),
    title: 'GASTRONOMIA MOLECULAR: A ARTE DE COZINHAR COM CIÊNCIA',
    description: 'O workshop irá apresentar a evolução histórica da ciência na cozinha, até culminar no que conhecemos hoje como gastronomia molecular. Serão apresentadas as principais técnicas e ingredientes utilizados nas cozinhas profissionais do século XXI, desenvolvidas dentro do âmbito de “cozinha molecular”. Por fim, teremos a apresentação e degustação de esferas, espumas e géis comestíveis.',
    speakers: [Speaker.find_or_create_by(name: 'Luiara Rosa Cavalcanti', event: events.third)],
    event: events.third,
  },
])

Vacancy.create([
  {
    user: users.last,
    talk: Talk.find_by(title: 'Desenvolvimento web é fácil'),
    presence: false,
  },
  {
    user: users[3],
    talk: Talk.find_by(title: 'Desenvolvimento web é fácil'),
    presence: false,
  }
])
