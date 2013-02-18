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

			# image = Gtk::Image.new @game.graphics.bitmap.pixbuf
			self.resizable = false

			@destroyed = false
			times = 0
			start_run = Time.new.to_f
			signal_connect 'destroy' do
				end_run = Time.new.to_f
				run_time = end_run - start_run
				puts "fps: #{times / run_time}"
				@destroyed = true
				@game.emit :done
			end

			@next_frame = Time.now.to_f + (1.0 / @game.ups)
			update = proc do
				times += 1
				unless @destroyed
					if @next_frame <= Time.now.to_f
						@game.emit :update
						@next_frame += (1.0 / @game.ups)
					end

					@game.graphics.update
					# @fixed.queue_draw

					EM.next_tick update
				end
			end
			update.call

			add @game.graphics.widget
		end

		def run
			show_all

			gtk_tick = proc { Gtk::main_iteration; EM.next_tick gtk_tick }
			gtk_tick.call
		end
	end
end