require_relative 'ship'
require_relative 'grid'

class Player

    COLUMN_INDEX = 0
    ROW_INDEX = 1

    def initialize(name, is_human, grid, opponent_grid)
        @name = name
        @grid = grid
        @is_humain = is_human
        @opponent_grid = opponent_grid
        @total_hits = 0
        @total_misses = 0
    end

    attr_accessor :grid, :name, :opponent_grid, :is_human, :total_hits, :total_misses

    def put_ship_on_board(ship_name, is_horizontal, starting_point, is_default=false)
        size = ship_name == 'Submarine' ? 2 : 3
        sign = ship_name == 'Submarine' ? 'S' : 'T'

        Ship.new(size, sign, is_human, grid, is_horizontal, starting_point, is_default)
    end

    def player_turn(player_name)
        grid_lines = grid.board
        grid.hide_all_ships(opponent_grid)
        
        opponent_grid_lines = opponent_grid.board
        grid.show_all_ships(opponent_grid)
        
        player_board = grid.create_board(grid_lines)
        opponent_board = grid.create_board(opponent_grid_lines)

        puts "Turn: #{player_name}\n"
        puts "Your Board:\n#{player_board}"
        puts "Opponent Board:\n#{opponent_board}"
    end

    def shot_result(positions)
        column = positions[COLUMN_INDEX]
        row = positions[ROW_INDEX]

        square_opponent_board = opponent_grid.board[row][column]

        if !Ship::SHIP_SIGNS.include? square_opponent_board
            square_opponent_board = Grid::DEFAULT_MISS

            @total_misses += 1
            @total_hits += 1

            puts 'Shot missed!'
        else
            square_opponent_board = Grid::DEFAULT_HIT
            total_hits += 1
            
            puts 'Hit!'
        end

        square_opponent_board
    end
end
