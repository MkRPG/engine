require_relative 'lib/boot'

require 'eventmachine'

require_relative 'lib/game'
require_relative 'lib/game/play'
require_relative 'lib/map'
require_relative 'lib/tile'
require_relative 'lib/tileset'
require_relative 'lib/bitmap'

EM.run do
	game = Game.new 'Lost Treasures of Panuragua'

	map = Map.new 'Home'
	game.add_map map
	tileset = Tileset.new(Bitmap.from_file 'C:\Program Files (x86)\Common Files\Enterbrain\RGSS\Standard\Graphics\Tilesets\001-Grassland01.png')
	tile = tileset[0, 0]
	map.tiles[0, 0, 0] = tile

	sprite = game.sprite Bitmap.from_file('C:\Users\Drew\Pictures\Sprites\Jet.png')
	sprite.x = 600

	game.window.signal_connect 'destroy' do
		EM.stop
	end

	move = proc do
		game.graphics.offset_x += 1
		EM.next_tick move
	end
	move.call

	game.play
end