class Tileset
	attr_reader :bitmap

	def initialize(bitmap)
		@bitmap = bitmap
	end

	def tile(x, y)
		Tile.new self, @bitmap.crop(y * TILE_SIZE, x * TILE_SIZE, TILE_SIZE, TILE_SIZE), x, y
	end

	alias :[] :tile
end