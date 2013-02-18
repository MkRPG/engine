require File.expand_path('../boot', __FILE__)

require 'eventmachine'

require 'mkrpg/engine'

class SceneTest < Scene
	# def initialize(game)
	# 	super
	# end

	def enter
		@sprite = @game.sprite 300, 300
		@bitmap = @sprite.bitmap
	end

	def update
		# @bitmap[0, 0] = Color.new(0, 0, 255)
		# for i in 0...100
		# 	g = i.to_f / 100 * 255
		# 	@bitmap.rect(Rect.new(0, i * 3, 300, 3), Color.new(g, g, g))
		# end

		@bitmap.text 0, 0, Time.now.to_s
	end

	def leave

	end
end

EM.run do
	game = Game.new 'Lost Treasures of Panuragua'

	map = Map.new 'Home'
	game.add_map map
	tileset = Tileset.new(Bitmap.from_file 'C:\Program Files (x86)\Common Files\Enterbrain\RGSS\Standard\Graphics\Tilesets\001-Grassland01.png')
	tile = tileset[0, 0]
	map.tiles[0, 0, 0] = tile

	# sprite = game.sprite Bitmap.from_file('C:\Users\Drew\Pictures\Sprites\Jet.png')
	# sprite.x = 600

	game.on :done do
		EM.stop
	end

	times = 0
	start_time = Time.now
	game.on :done do
		end_time = Time.now
		duration = (end_time - start_time).to_f
		puts "ups: #{times / duration}"
	end
	game.on :update do
		times += 1
		# game.graphics.offset_x += 1
	end

	game.scene = SceneTest.new(game)

	game.play
end