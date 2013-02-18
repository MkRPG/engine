require 'eventmachine'
require 'gtk2'

require_relative 'window'

class Game
	attr_reader :window

	def window
		@window ||= Window.new self
	end

	def play
		window.run
		
		self
	end
end