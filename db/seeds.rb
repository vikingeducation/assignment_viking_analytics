puts "Starting seeds...\n\n"
start_time = Time.now

puts "Removing old data..."
# Blow away the existing data
State.delete_all
City.delete_all
Airline.delete_all
User.delete_all
Flight.delete_all
Itinerary.delete_all
Ticket.delete_all
puts "Old data removed.\n\n"



# increase your seed size by changing this
# NOTE: This can make it take MUCH longer!
# A value of 10 can take over 3 minutes
MULTIPLIER = 5


srand(42)

# start and end times
START_TIME = Time.find_zone("Pacific Time (US & Canada)").local(2011,1,1)
END_TIME = Time.find_zone("Pacific Time (US & Canada)").local(2014,1,1)

PAYMENT_METHODS = %w(VISA MasterCard AmEx Discover Check Cash StockOptions Doubloons)

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

# CREATE STATES
STATES =
["Alabama", "Alaska", "Arizona", "Arkansas", "California",
"Colorado", "Connecticut", "Delaware", "Florida", "Georgia",
"Hawaii", "Idaho", "Illinois", "Indiana", "Iowa",
"Kansas", "Kentucky", "Louisiana", "Maine", "Maryland",
"Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri",
"Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey",
"New Mexico", "New York", "North Carolina", "North Dakota", "Ohio",
"Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina",
"South Dakota", "Tennessee", "Texas", "Utah", "Vermont",
"Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"]

puts "Creating States..."
STATES.each do |state_name|
  State.create({:name => state_name})
end
puts "States created.\n\n"


puts "Creating Cities..."
State.all.each do |state|
  MULTIPLIER.times do
    City.create( name: Faker::Address.city )
  end
end
puts "Cities created.\n\n"


puts "Creating Airports..."
City.all.each do |city|
  Airport.create(city_id:  city.id,
                 long_name: "#{city.name} Probably International Airport",
                 state_id: State.all.sample.id,
                 code: airport_code )
end
puts "Airports created.\n\n"


puts "Creating Airlines..."
MULTIPLIER.times do
  Airline.create(name: "#{Faker::Company.name} #{["Air", "Airlines", "Flights"].sample}")
end
puts "Airlines created.\n\n"


puts "Creating Users..."
(MULTIPLIER * 25).times do
  fname =  Faker::Name.first_name
  lname = Faker::Name.last_name
  User.create( city_id: City.pluck(:id).sample,
               state_id: State.pluck(:id).sample,
               username: Faker::Internet.user_name,
               email: Faker::Internet.email("#{fname} #{lname}"),
               first_name: fname,
               last_name: lname  )
end
puts "Users created.\n\n"


puts "Creating Flights..."
Airline.all.each do |airline|
  (MULTIPLIER * 100).times do
    origin_id, destination_id = Airport.pluck(:id).sample(2)
    departure_time = random_time
    Flight.create(origin_id: origin_id,
                  destination_id: destination_id,
                  departure_time: departure_time,
                  airline_id: Airline.pluck(:id).sample,
                  arrival_time: random_hours_later(departure_time),
                  price: rand(99.99..850.00).round(2),
                  distance: rand(100..600))
  end
end
puts "Flights created.\n\n"


puts "Creating Itineraries..."
User.all.each do |user|
  rand(4).times do
    Itinerary.create!(user_id: user.id,
                     payment_method: PAYMENT_METHODS.sample)
  end
end
puts "Itineraries created.\n\n"


puts "Creating Tickets..."
Itinerary.all.each do |itinerary|
  rand(MULTIPLIER).times do
    Ticket.create(itinerary_id: itinerary.id,
                  flight_id: Flight.pluck(:id).sample)
  end
end
puts "Tickets created.\n\n"


puts "\n\nALL DONE!!!"
puts "It took #{Time.now - start_time} seconds."
