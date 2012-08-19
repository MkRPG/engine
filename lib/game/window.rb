require 'gtk2'
require 'pry'

require_relative '../utils/event_emitter'

class Game
	class Window < Gtk::Window
		include EventEmitter

		attr_reader :game

		def initialize(game)
			super()

			@game = game

			set_title @game.name
			set_default_size @game.width, @game.height

			image = Gtk::Image.new @game.graphics.bitmap.pixbuf
			self.resizable = false

			@destroyed = false
			signal_connect 'destroy' do
				@destroyed = true
			end

			update = proc do
				unless @destroyed
					@game.graphics.update

					image.queue_draw

					EM.next_tick update
				end
			end
			update.call

			add image
		end

		def run
			show_all

			gtk_tick = proc { Gtk::main_iteration; EM.next_tick gtk_tick }
			gtk_tick.call
		end
	end
end