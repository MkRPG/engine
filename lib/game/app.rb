require_relative '../boot'

require 'chunky_png'
require 'eventmachine'

require_relative 'app/window'

class Game
	def app
		App.new self
	end

	def play
		app.run
	end

	class App
		attr_reader :game

		def initialize(game)
			@game = game
			@window = Window.new
		end

		def run
			@window.show
			tick = proc { Gtk::main_iteration; EM.next_tick tick }
			tick.call
		end
	end
end