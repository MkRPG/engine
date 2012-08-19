require_relative 'bitmap'
require_relative 'constants'

class Graphics
	attr_reader :bitmap
	attr_accessor :offset_x, :offset_y

	def initialize(game)
		@game = game
		@offset_x = @offset_y = 0
		
		resize @game.width, @game.height
	end

	def resize(width, height)
		@bitmap = Bitmap.new width, height
	end

	def update
		@bitmap.clear 0

		@game.sprites.each do |sprite|
			@bitmap.draw sprite.x - @offset_x, sprite.y - @offset_y, sprite.bitmap
		end

		self
	end
end