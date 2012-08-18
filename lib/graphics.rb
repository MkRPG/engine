require_relative 'bitmap'
require_relative 'constants'

class Graphics
	def initialize(game)
		@game = game
		@bitmap = Bitmap.new 640, 480
	end

	def update
		@game.sprites.each do |sprite|
			@bitmap.draw sprite.x, sprite.y, sprite.bitmap
		end

		self
	end
end