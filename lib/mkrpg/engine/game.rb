require_relative 'graphics'
require_relative 'sprite'
require_relative 'scene'
require_relative 'utils/event_emitter'

module MkRPG
	module Engine
		class Game
			include EventEmitter

			DEFAULT_UPS = 60

			attr_accessor :name
			attr_reader :maps
			attr_reader :tilesets
			attr_reader :graphics
			attr_reader :scene
			attr_reader :sprites
			attr_accessor :width, :height
			attr_accessor :ups

			def initialize(name = nil)
				@name = name ? name.to_s : name
				@tilesets = []
				@maps = []
				@sprites = []
				@width, @height = 640, 480
				@graphics = Graphics.new self
				@ups = DEFAULT_UPS

				on :update do
					@scene.update if @scene.is_a? Scene
				end

				$game = self
			end

			def scene=(scene)
				raise ArgumentError, "Not a scene" unless scene.is_a? Scene

				@scene.leave if @scene.is_a? Scene

				@sprites.reject(&:persistent?).each do |sprite|
					remove_sprite sprite
				end

				@scene = scene
				@scene.enter
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

			def remove_sprite(sprite)
				@sprites.delete sprite
				emit :remove_sprite, sprite

				self
			end

			def sprite(*args)
				sprite = Sprite.new self, *args

				@sprites << sprite

				emit :sprite, sprite

				sprite
			end
		end
	end
end