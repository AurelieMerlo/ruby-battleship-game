require_relative 'grid'
require_relative 'player'
require_relative 'ship'

class Game

    def initialize(first_player_name, second_player_name)
        @first_player_board = Grid.new()
        @second_player_board = Grid.new()
        @first_player = Player.new(first_player_name, true, first_player_board, second_player_board)
        @second_player = Player.new(second_player_name, true, second_player_board, first_player_board)
        @first_player_ships = Ship::SHIP_SIGNS
        @second_player_ships = Ship::SHIP_SIGNS
        @turn = 0
    end

    attr_accessor :first_player_board, :second_player_board, :first_player, :second_player, :first_player_ships, :second_player_ships, :turn

    def start_game
        first_player_board.place_ships(first_player)
        second_player_board.place_ships(second_player)

        while true
            first_player.player_turn(first_player.name)

            hit_position = get_user_input
            hit_position = convert_input_to_coordinates(hit_position[0], hit_position[1])

            is_hit = first_player.shot_result(hit_position)

            second_player_ships.each do |sign|
                if ship_is_destroyed?(sign, second_player_board)
                    second_player_ships.delete(sign)
                    puts "Opponent ship #{sign} has been sunk!"
                end
            end

            if !is_hit
                puts 'Press enter to pass to player 2'
            end

            is_win = all_ships_are_destroyed?(second_player_board)
            if is_win
                puts "#{first_player.name} win game!"
                exit -1
            end

            if is_hit
                next
            end

            turn = 1

            while turn == 1
                second_player.player_turn(second_player.name)

                hit_position = get_user_input
                hit_position = convert_input_to_coordinates(hit_position[0], hit_position[1])

                is_hit = second_player.shot_result(hit_position)

                first_player_ships.each do |sign|
                    if ship_is_destroyed?(sign, first_player_board)
                        first_player_ships.delete(sign)
                        puts "Opponent ship: #{sign} has been sunk!"
                    end
                end

                if !is_hit
                    puts 'Press enter to pass to player 2'
                end

                is_win = all_ship_are_destroyed?(first_player_board)
                if is_win
                    puts "#{second_player.name} win game!"
                    exit -1
                end

                if is_hit
                    turn = 1
                else
                    turn = 0
                end
            end
        end
    end

    def get_user_input
        board_letter = Grid::BOARD_LETTER

        while true
            puts "'Enter coordinates (column,row): '"
            hit_position = gets.chomp.split(',')
            letter = hit_position[1].to_s
            
            hit_position = [board_letter[letter.to_s], hit_position[0].to_i]

            return hit_position
        end
    end

    def convert_input_to_coordinates(row, column)
        board_letter = Grid::BOARD_LETTER

        row = (row || 0) - 1 

        if board_letter.key?(column)
            return board_letter[:colum] 
        end

        [row, column]
    end

    def ship_is_destroyed?(sign, grid)
        grid.board.each do |row|
            row.each do |square|
                if square == sign
                    return false
                end
            end
        end

        true
    end

    def all_ships_are_destroyed?(grid)
        grid.board.each do |row|
            row.each do |square|
                if Ship::SHIP_SIGNS.include? square
                    return false
                end
            end
        end

        true
    end

end