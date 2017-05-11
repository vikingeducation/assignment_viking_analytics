# ----------------------------------------
# Multiplier
# ----------------------------------------
# Increase your seed size by changing this
# NOTE: This can make it take MUCH longer!
# A value of 10 can take over 3 minutes
MULTIPLIER = 1




# ----------------------------------------
# Constants
# ----------------------------------------

START_TIME = Time.find_zone("Pacific Time (US & Canada)").local(2011, 1, 1)
END_TIME = Time.find_zone("Pacific Time (US & Canada)").local(2014, 1, 1)

PAYMENT_METHODS = [
  "VISA",
  "MasterCard",
  "AmEx",
  "Discover",
  "Check",
  "Cash",
  "StockOptions",
  "Doubloons"
]

STATES = [
  "Alabama",
  "Alaska",
  "Arizona",
  "Arkansas",
  "California",
  "Colorado",
  "Connecticut",
  "Delaware",
  "Florida",
  "Georgia",
  "Hawaii",
  "Idaho",
  "Illinois",
  "Indiana",
  "Iowa",
  "Kansas",
  "Kentucky",
  "Louisiana",
  "Maine",
  "Maryland",
  "Massachusetts",
  "Michigan",
  "Minnesota",
  "Mississippi",
  "Missouri",
  "Montana",
  "Nebraska",
  "Nevada",
  "New Hampshire",
  "New Jersey",
  "New Mexico",
  "New York",
  "North Carolina",
  "North Dakota",
  "Ohio",
  "Oklahoma",
  "Oregon",
  "Pennsylvania",
  "Rhode Island",
  "South Carolina",
  "South Dakota",
  "Tennessee",
  "Texas",
  "Utah",
  "Vermont",
  "Virginia",
  "Washington",
  "West Virginia",
  "Wisconsin",
  "Wyoming"
]




# ----------------------------------------
# Helper Functions
# ----------------------------------------

def random_time
  rand(START_TIME..END_TIME)
end

def random_hours_later(time)
  time + rand(7).hours + rand(60).minutes
end

def airport_code
  letters = Array("A".."Z")
  result = ''
  3.times{ result << letters.sample }
  result
end

def print_num_of(current, total)
  print "\r#{current} of #{total}"
end




# ----------------------------------------
# Seeds
# ----------------------------------------


puts "Starting seeds...\n\n"
start_time = Time.now




puts "Removing old data..."
State.delete_all
City.delete_all
Airline.delete_all
User.delete_all
Flight.delete_all
Itinerary.delete_all
Ticket.delete_all
puts "Old data removed.\n\n"




puts "Creating States..."

num_states = STATES.length
num_states_created = 0

STATES.each do |state_name|
  State.create(:name => state_name)


  num_states_created += 1
  print_num_of(num_states_created, num_states)
end
puts
puts "States created.\n\n"




puts "Creating Cities..."

num_cities = STATES.length * MULTIPLIER
num_cities_created = 0

State.all.each do |state|
  MULTIPLIER.times do
    City.create(name: Faker::Address.city)


    num_cities_created += 1
    print_num_of(num_cities_created, num_cities)
  end
end
puts
puts "Cities created.\n\n"




puts "Creating Airports..."

num_airports = City.count
num_airports_created = 0

City.all.each do |city|
  Airport.create(
    city_id: city.id,
    long_name: "#{city.name} Probably International Airport",
    state_id: State.all.sample.id,
    code: airport_code
  )


  num_airports_created += 1
  print_num_of(num_airports_created, num_airports)
end
puts
puts "Airports created.\n\n"




puts "Creating Airlines..."

num_airlines = MULTIPLIER
num_airlines_created = 0

MULTIPLIER.times do
  name = [
    Faker::Company.name,
    ["Air", "Airlines", "Flights"].sample
  ].join(' ')
  Airline.create(name: name)


  num_airlines_created += 1
  print_num_of(num_airlines_created, num_airlines)
end
puts
puts "Airlines created.\n\n"




puts "Creating Users..."

num_users = MULTIPLIER * 25
num_users_created = 0

(num_users).times do
  fname =  Faker::Name.first_name
  lname = Faker::Name.last_name
  User.create(
    city_id: City.pluck(:id).sample,
    state_id: State.pluck(:id).sample,
    username: Faker::Internet.user_name,
    email: Faker::Internet.email("#{fname} #{lname}"),
    first_name: fname,
    last_name: lname
  )


  num_users_created += 1
  print_num_of(num_users_created, num_users)
end
puts
puts "Users created.\n\n"




puts "Creating Flights..."

airline_count = Airline.count
flights_per_airline = MULTIPLIER * 100
num_flights = flights_per_airline * airline_count
num_flights_created = 0

Airline.all.each do |airline|
  (flights_per_airline).times do |i|
    origin_id, destination_id = Airport.pluck(:id).sample(2)
    departure_time = random_time
    Flight.create(
      origin_id: origin_id,
      destination_id: destination_id,
      departure_time: departure_time,
      airline_id: Airline.pluck(:id).sample,
      arrival_time: random_hours_later(departure_time),
      price: rand(99.99..850.00).round(2),
      distance: rand(100..600)
    )


    num_flights_created += 1
    print_num_of(num_flights_created, num_flights)
  end
end
puts
puts "Flights created.\n\n"




puts "Creating Itineraries..."

randoms = []
User.count.times { randoms << rand(1..4) }
num_itineraries = randoms.reduce(:+)
num_itineraries_created = 0

User.all.each do |user|
  num = randoms.pop
  num.times do
    Itinerary.create!(
      user_id: user.id,
      payment_method: PAYMENT_METHODS.sample
    )


    num_itineraries_created += 1
    print_num_of(num_itineraries_created, num_itineraries)
  end
end
puts
puts "Itineraries created.\n\n"




puts "Creating Tickets..."

randoms = []
Itinerary.count.times { randoms << rand(1..MULTIPLIER) }
num_tickets = randoms.reduce(:+)
num_tickets_created = 0

Itinerary.all.each do |itinerary|
  num = randoms.pop
  time = random_time
  num.times do
    Ticket.create(
      itinerary_id: itinerary.id,
      flight_id: Flight.pluck(:id).sample,
      created_at: time,
      updated_at: time
    )


    num_tickets_created += 1
    print_num_of(num_tickets_created, num_tickets)
  end
end
puts
puts "Tickets created.\n\n"




puts "\n\nALL DONE!!!"
puts "It took #{Time.now - start_time} seconds."





