require_relative 'boot'

class Map
	attr_accessor :name

	def initialize(name = nil)
		@name = if name then name.to_s else name end
		@pos = {}
	end

	def [](x, y)
		@pos[x] ||= {}
		pos = Pos.new x, y
		@pos[x][y] ||= pos

		pos
	end

	class Pos
		attr_accessor :x, :y

		def initialize(x, y)
			@x = x
			@y = y
			@layers = {}
		end

		def []=(layer, tile)
			@layers[layer] = tile
		end
	end
end