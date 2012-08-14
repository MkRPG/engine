require_relative 'lib/boot'

require 'eventmachine'

require_relative 'lib/game'
require_relative 'lib/game/app'
require_relative 'lib/map'
require_relative 'lib/map/tile'

EM.run do
	game = Game.new 'Lost Treasures of Panuragua'

	map = Map.new 'Home'
	tile = Tile.new
	map[0, 0][0] = tile
	game.maps << map

	game.play
end