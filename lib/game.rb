require_relative 'graphics'

class Game
	attr_accessor :name
	attr_reader :maps
	attr_reader :tilesets
	attr_reader :graphics
	attr_reader :sprites

	def initialize(name = nil)
		@name = name ? name.to_s : name
		@tilesets = []
		@maps = []
		@sprites = []
		@graphics = Graphics.new self
		$game = self
	end

	def add_tileset(tileset)
		@tilesets << tileset unless @tilesets.include? tileset

		self
	end

	def add_map(map)
		map.game = self
		@maps << map unless @maps.include? map

		self
	end

	def sprite(bitmap = nil)

	end
end