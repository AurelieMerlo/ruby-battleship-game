require_relative 'lib/game'

puts 'Welcome to the Battleship game!'
puts "\n"
puts 'Choose an option:
(1) start
(2) exit
'

option = gets.chomp

case option
when '1'
    puts "Let's go!"

    sleep(1)

    puts '[1st player] Enter your name: '
    first_player_name = gets.chomp

    puts '[2nd player] Enter your name: '
    second_player_name = gets.chomp

    game = Game.new(first_player_name, second_player_name)
    game.start_game()
when '2'
    puts 'Thanks! Goodbye!'
    exit -1
else
    puts "Unknown option #{option}. Please choose between (1) or (2)"
end
