# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Employee.create(name: 'Biojout', first_name: 'Raphaël', email: 'rbiojout@gmail.com')

Country.create([{name: 'France', eu_member: true, currency: 'EUR'}, {name: 'USA', eu_member: false, currency: 'EUR'}])
usa = Country.find_by(name: 'USA')
Family.create [{name: 'Maths', country_id: usa.id}, {name: 'English', country_id: usa.id}, {name: 'Science', country_id: usa.id}, {name: 'History', country_id: usa.id}, {name: 'Geography', country_id: usa.id}, {name: 'Language', country_id: usa.id}, {name: 'Computing', country_id: usa.id}, {name: 'Design and Technology', country_id: usa.id}, {name: 'Art and Design', country_id: usa.id}, {name: 'Physical Education', country_id: usa.id}, {name: 'Citizenship', country_id: usa.id}, {name: 'Music', country_id: usa.id}]
Cycle.create([{name: 'Early years', country_id: usa.id}, {name: 'Primary', country_id: usa.id}, {name: 'Secondary', country_id: usa.id}, {name: 'Higher education'}])
france = Country.find_by(name: 'France')
Family.create [{name: 'Mathématiques', country_id: france.id}, {name: 'Français', country_id: france.id}, {name: 'Histoire', country_id: france.id}, {name: 'Géographie', country_id: france.id}, {name: 'Education civique', country_id: france.id}, {name: 'SVT', country_id: france.id}, {name: 'Technologie', country_id: france.id}, {name: 'Langues vivantes', country_id: france.id}, {name: 'Education artistique', country_id: france.id}, {name: 'EPS', country_id: france.id}]
Cycle.create([{name: 'Maternelle', country_id: france.id}, {name: 'Primaire', country_id: france.id}, {name: 'Collège', country_id: france.id}, {name: 'Lycée', country_id: france.id}, {name: 'Supérieur', country_id: france.id}])
cycle0 = Cycle.find_by(name: 'Maternelle')
Level.create([{name: 'Petite Section', cycle_id: cycle0.id}, {name: 'Moyenne Section', cycle_id: cycle0.id}, {name: 'Grande section', cycle_id: cycle0.id}])
cycle1 = Cycle.find_by(name: 'Primaire')
Level.create([{name: 'CP', cycle_id: cycle1.id}, {name: 'CE1', cycle_id: cycle1.id}, {name: 'CE2', cycle_id: cycle1.id}, {name: 'CM1', cycle_id: cycle1.id}, {name: 'CM2'}])
cycle2 = Cycle.find_by(name: 'Collège')
Level.create([{name: '6ème', cycle_id: cycle2.id}, {name: '5ème', cycle_id: cycle2.id}, {name: '4ème', cycle_id: cycle2.id}, {name: '3ème', cycle_id: cycle2.id}])
cycle3 = Cycle.find_by(name: 'Lycée')
Level.create([{name: 'Seconde', cycle_id: cycle3.id}, {name: '1ère', cycle_id: cycle3.id}, {name: 'Terminale', cycle_id: cycle3.id}])
