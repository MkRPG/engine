require 'eventmachine'
require 'gtk2'

require_relative 'window'

class Game
	attr_reader :window

	def play
		@window = Window.new self
		@window.run
		
		self
	end
end