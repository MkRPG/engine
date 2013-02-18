class Tile
	attr_reader :tileset
	attr_reader :bitmap
	attr_reader :x, :y

	def initialize(tileset, bitmap, x, y)
		@tileset = tileset
		@bitmap = bitmap
		@x = x
		@y = y
	end
end