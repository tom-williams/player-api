# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
player_1 = Player.create(
  firstname: 'Johnny',
  lastname: 'AppleSeed',
  password: '12345678',
  password_confirmation: '12345678',
  email: 'ja@example.com',
  position: 'Goalkeeper',
  date_of_birth: DateTime.new(2006, 1, 11)
)

player_2 = Player.create(
  firstname: 'Johnny B.',
  lastname: 'Goode',
  password: '12345678',
  password_confirmation: '12345678',
  email: 'jg@example.com',
  position: 'Holding Midfielder',
  date_of_birth: DateTime.new(2005, 2, 12)
)

player_3 = Player.create(
  firstname: 'Karius',
  lastname: 'Baktus',
  password: '12345678',
  password_confirmation: '12345678',
  email: 'kb@example.com',
  position: 'Attacking Midfielder Central',
  date_of_birth: DateTime.new(2004, 3, 13)
)

player_4 = Player.create(
  firstname: 'Bronto',
  lastname: 'Saurus',
  password: '12345678',
  password_confirmation: '12345678',
  email: 'bs@example.com',
  position: 'Central Defender',
  date_of_birth: DateTime.new(2003, 4, 14)
)

player_5 = Player.create(
  firstname: 'George',
  lastname: 'Weahs Cousin',
  password: '12345678',
  password_confirmation: '12345678',
  email: 'gwc@example.com',
  position: 'Striker',
  date_of_birth: DateTime.new(2002, 5, 15)
)

player_1.followers << player_5
player_1.followers << player_4
player_2.followers << player_1
player_2.followers << player_3
player_2.followers << player_4