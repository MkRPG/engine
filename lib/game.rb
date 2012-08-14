require_relative 'boot'

class Game
	attr_accessor :name
	attr_reader :maps

	def initialize(name = nil)
		@name = if name then name.to_s else name end
		@maps = []
	end
end