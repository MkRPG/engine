require 'gtk2'
require 'pry'

require_relative '../utils/event_emitter'

class Game
	class Window < Gtk::Window
		include EventEmitter

		attr_reader :game

		def initialize(game)
			super()

			signal_connect 'destroy' do
				EM.stop
			end

			signal_connect 'expose-event' do
				
			end

			set_default_size 640, 480

			drawingArea = Gtk::DrawingArea.new
			drawingArea.signal_connect "configure-event" do
				cr = drawingArea.window.create_cairo_context

				cr.set_source @game.graphics.update().bitmap.surface

				# image = Cairo::ImageSurface.from_png 'C:\Users\Drew\Pictures\Sprites\Jet.png'
				# cr.set_source image, 0, 0
				# cr.rectangle 0, 0, image.width, image.height
				# cr.fill

				# cr.set_source_rgb 0, 0, 0
				# cr.rectangle image.width + 10, image.height + 10, 1, 1
				# cr.fill

				# binding.pry
				# cr.set_source_rgb 1, 1, 0
				# cr.rectangle 10, 15, 90, 60
				# cr.fill
			end

			add drawingArea

			@game = game
		end

		def run
			show_all

			gtk_tick = proc { Gtk::main_iteration; EM.next_tick gtk_tick }
			gtk_tick.call
		end
	end
end