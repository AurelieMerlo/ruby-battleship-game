require_relative '../../lib/ship'
require_relative '../../lib/grid'

RSpec.describe Ship do
  describe '#initialize' do

    it 'has empty errors' do
      grid = Grid.new()
      ship = Ship.new('2', 'S', false, grid, false, [1,0], false)
      board = Array.new(Grid::DEFAULT_GRID_WIDTH) { Array.new(Grid::DEFAULT_GRID_LENGTH, Grid::DEFAULT_EMPTY) }

      expect(ship.size).to eq '2'
      expect(ship.sign).to eq 'S'
      expect(ship.is_horizontal).to eq false
      expect(ship.grid.board).to match_array(board)
    end
      
  end
end