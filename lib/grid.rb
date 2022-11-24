require_relative 'player'
require 'terminal-table'
require 'io/console'

class Grid
    
    COLUMN_NAMES = [' ', '1', '2', '3', '4', '5']
    ROW_NAMES = ['A', 'B', 'C', 'D', 'E']
    BOARD_LETTER = {
        A: 0, 
        B: 1, 
        C: 2, 
        D: 3, 
        E: 4
    }
    MOVEMENT_KEYS = ['w', 's', 'a', 'd']
    DEFAULT_GRID_WIDTH = 5
    DEFAULT_GRID_LENGTH = 5
	DEFAULT_EMPTY = ' '
	DEFAULT_HIT = 'X'
	DEFAULT_MISS = 'O'

    def initialize
        @board = Array.new(DEFAULT_GRID_WIDTH) { Array.new(DEFAULT_GRID_LENGTH, DEFAULT_EMPTY) }
    end

    attr_accessor :board, :print_board

    def create_board(board_to_print)
        new_board = Terminal::Table.new()
        new_board.add_row(COLUMN_NAMES)

        board_to_print.each do |row|
            row[0] = ROW_NAMES[0]
            new_board.add_row(row)
            new_board.add_separator
            ROW_NAMES.shift
        end

        new_board
    end

    def is_horizontal?(ship_name)
        while true
            puts "Do you want to place your #{ship_name} boat horizontally (h) or vertically (v)"
            direction = gets.chomp
            case direction
            when 'h'
                return true
            when 'v'
                return false
            else
                puts "Wrong direction!"
            end
        end
    end

    def place_ships(player)
        ships = Ship::SHIPS

        puts "Creating #{player.name}'s board"

        default_grid = Grid.new()
        default_player = Player.new('default', false, default_grid, player.grid)

        puts create_board(default_player.grid.board)

        while ships.size > 0
            starting_position = [1, 0]
            is_horizontal = is_horizontal?(ships[0])

            while true
                puts "Creating #{player.name}'s board"

                default_player.grid.board = player.grid.board

                default_player.put_ship_on_board(ships[0], is_horizontal, starting_position, true)

                puts create_board(default_player.grid.board)

                puts "Use W,A,S,D to move your ship, than P to place it. Quit with Q"

                move_ship = STDIN.getch # toLowerCase()

                if MOVEMENT_KEYS.include? move_ship
                    starting_position = move_ship_on_board(is_horizontal, starting_position, ships[0], move_ship)
                elsif move_ship == 'p'
                    player.put_ship_on_board(ships[0], is_horizontal, starting_position, false)
                    ships.shift
                    break
                elsif move_ship =='q'
                    exit -1
                else
                    puts 'Incorrect input!'
                end
            end
        end
    end

    def move_ship_on_board(is_horizontal, position, ship_type, move_ship)
        ship_length = Ship::SHIPS_LENGTHS[:ship_type]

        @board = Array.new(DEFAULT_GRID_WIDTH) { Array.new(DEFAULT_GRID_LENGTH, DEFAULT_EMPTY) }

        if is_horizontal
            if move_ship == 'w'
                if position[1] > 1
                    position[1] -= 1
                end
            elsif move_ship == 's'
                if position[1] < 4
                    position[1] += 1
                end 
            elsif move_ship == 'a'
                if position[0] > 1
                    position[0] -= 1
                end
            elsif move_ship == 'd'
                if position[0] < 4 - (ship_length || 0)
                    position[0] += 1
                end
            end
        else
            if move_ship == 'w'
                if position[1] > 1
                    position[1] -= 1
                end
            elsif move_ship == 's'
                if position[1] < 4 - (ship_length || 0)
                    position[1] += 1
                end 
            elsif move_ship == 'a'
                if position[0] > 1
                    position[0] -= 1
                end
            elsif move_ship == 'd'
                if position[0] < 4
                    position[0] += 1
                end
            end
        end

        position
    end

    def hide_all_ships(grid)
        grid.board.each do |row|
            row.each_with_index do |square, index|
                if Ship::SHIP_SIGNS.include? square
                    row[index] = ''
                end
            end
        end

        grid
    end

    def show_all_ships(grid)
        grid.board.each do |row|
            row.each do |square|
                if square.instance_of? ShipSquare
                    square.change_sign(square.final_sign)
                end
            end
        end

        grid
    end
end