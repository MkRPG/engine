require_relative 'graphics'
require_relative 'sprite'

class Game
	attr_accessor :name
	attr_reader :maps
	attr_reader :tilesets
	attr_reader :graphics
	attr_reader :sprites
	attr_accessor :width, :height

	def initialize(name = nil)
		@name = name ? name.to_s : name
		@tilesets = []
		@maps = []
		@sprites = []
		@width, @height = 640, 480
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

	def sprite(*args)
		sprite = Sprite.new self, *args

		@sprites << sprite

		sprite
	end
end