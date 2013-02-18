require 'gtk2'
require_relative 'bitmap'
require_relative 'constants'

class Graphics
	attr_reader :widget
	attr_accessor :offset_x, :offset_y

	def initialize(game)
		@game = game
		@offset_x = @offset_y = 0
		@widget = Gtk::Fixed.new
		@images = Hash.new do |h, sprite|
			widget = nil

			if sprite.respond_to?(:bitmap)
				widget = sprite.bitmap.pixbuf
			elsif sprite.respond_to?(:widget)
				widget = sprite.widget
			end

			h[sprite] = if widget.is_a? Gdk::Pixbuf
			            	Gtk::Image.new widget
			            elsif widget.is_a? Gtk::Widget
			            	widget
			            end
		end

		@game.on :sprite do |sprite|
			puts "adding sprite"
			@widget.put @images[sprite], *sprite_pos(sprite)
		end

		@game.on :remove_sprite do |sprite|
			puts "removing sprite"
			@widget.remove @images[sprite] if @images.has_key? sprite
		end
		
		resize @game.width, @game.height
	end

	def resize(width, height)
		@widget.set_size_request width, height
	end

	def update
		@game.sprites.each do |sprite|
			@widget.move @images[sprite], *sprite_pos(sprite)
		end

		self
	end

private

	def sprite_pos(sprite)
		[sprite.x - @offset_x, sprite.y - @offset_y]
	end
end