require_relative 'square'

class Ship

    SHIPS = { 
        'Submarine': { sign: 'S', length: 2 },
        'Titanic': { sign: 'T', length: 3 }
    }
    SHIP_SIGNS = SHIPS.each {|key, value| key[0] }

    ROW_INDEX = 0
    LINE_INDEX = 1

    MIN_INDEX = 0
    MAX_INDEX = 5

    def initialize(size, sign, player_create, grid, is_horizontal, starting_point, is_default=False)
        @size = size
        @sign = sign
        @grid = grid
        @is_horizontal = is_horizontal
        create_ship_by_user(starting_point) if player_create
        create_ship_by_default(starting_point) if is_default
    end

    attr_accessor :board, :is_horizontal, :size, :grid, :sign

    def create_ship_by_user(starting_point)
        x = starting_point[ROW_INDEX]
        y = starting_point[LINE_INDEX]

        if is_horizontal
            if x <= MIN_INDEX or x + size > MAX_INDEX or y <= MIN_INDEX or y >= MAX_INDEX
                raise 'Your ship is out off the grid!'
            end
        else
            if y <= MIN_INDEX or y + size > MAX_INDEX or x <= MIN_INDEX or x >= MAX_INDEX
                raise 'Your ship is out off the grid!'
            end
        end

        if another_ship?(x, y)
            raise 'You cant put ship on another ship!'
        end

        if is_horizontal
            grid.board[y][x..x + size] = (1..size).map {|i| ShipSquare.new(sign).sign}
        else
            grid.board[y...y + size].each do |n|
                n[x] = ShipSquare.new(sign).sign
            end
        end
    end

    def create_ship_by_default(position)
        x = position[ROW_INDEX]
        y = position[LINE_INDEX]

        if another_ship?(x, y)
            raise 'You cant put ship on another ship!'
        end

        if is_horizontal
            grid.board[y][x...x + size] = (1..size).map {|i| ShipSquare.new(sign).sign}
        else
            grid.board[y...y + size].each do |n|
                n[x] = ShipSquare.new(sign).sign
            end
        end
    end

    def another_ship?(x, y)
        return true if SHIP_SIGNS.include? grid.board[x][y]

        return false
    end

end