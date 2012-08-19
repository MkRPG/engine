class Sprite
	attr_reader :game
	attr_reader :bitmap
	attr_accessor :x, :y

	def initialize(game, bitmap = nil, height = nil)
		@game = game
		@bitmap = bitmap || Bitmap.new(bitmap, height)

		@x = @y = 0
	end
end