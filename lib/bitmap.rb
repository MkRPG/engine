require 'gtk2'

require_relative 'color'

Rect = Struct.new "Rect", :x, :y, :w, :h

class Bitmap
	attr_reader :pixbuf
	attr_reader :height, :width

	def initialize(width, height)
		@pixbuf = Gdk::Pixbuf.new width, height

		update_dimensions
	end

	def initialize_with_pixbuf(pixbuf)
		@pixbuf = pixbuf

		update_dimensions
	end

	alias :pixbuf= :initialize_with_pixbuf

	def self.from_file(path)
		from_pixbuf Gdk::Pixbuf.new(path)
	end

	def self.from_pixbuf(pixbuf)
		bitmap = allocate
		bitmap.initialize_with_pixbuf pixbuf
		bitmap
	end

	def [](x, y)
		pixel_hash[[x, y]]
	end

	def []=(x, y, val)
		unless val.is_a? Color
			raise ArgumentError, 'New value is not a color'
		end

		pixel_hash[[x, y]] = val

		set_pixel [x, y], val
	end

	def save
		0.upto width do |x|
			0.upto height do |y|
				save_pixel [ x, y ]
			end
		end
	end

	def crop(x, y, width, height)
		Bitmap.from_pixbuf crop_pixbuf(x, y, width, height)
	end

	def crop!(x, y, width, height)
		self.pixbuf = crop_pixbuf(x, y, width, height)

		self
	end

	def surface
		require 'gtk2'

		surface = Cairo::ImageSurface.new @width, @height

		context = Cairo::Context.new surface

		context.set_source_pixbuf @pixbuf
		context.rectangle 0, 0, @width, @height
		context.fill

		surface
	end

private
	
	def crop_pixbuf(x, y, width, height)
		Gdk::Pixbuf.new @pixbuf, x, y, width, height
	end

	def pixel_hash
		@pixel_hash ||= Hash.new &method(:get_pixel)
	end

	def get_pixel(h, a)
		x, y = a

		pixbuf = Gdk::Pixbuf.new(@pixbuf, x, y, 1, 1)
		color = Color.new

		color.r = pixbuf.pixels[0].getbyte 0
		color.g = pixbuf.pixels[1].getbyte 0
		color.b = pixbuf.pixels[2].getbyte 0

		# puts "has_alpha?: #{pixbuf.has_alpha?}"

		if pixbuf.has_alpha?
			color.a = pixbuf.pixels[3].getbyte 0
		end

		h[a] = color

		color
	end

	def set_pixel(a, color)
		pixel_hash[a] = color
	end

	def save_pixel(a)
		x, y = a

		pixbuf = Gdk::Pixbuf.new(@pixbuf, x, y, 1, 1)

		pixels = pixbuf.pixels
		pixels[0].setbyte 0, color.r
		pixels[1].setbyte 0, color.g
		pixels[2].setbyte 0, color.b

		# puts "has_alpha?: #{pixbuf.has_alpha?}"

		if pixbuf.has_alpha?
			pixels[3].setbyte 0, color.a
		end

		color
	end

	def update_dimensions
		@width = @pixbuf.width
		@height = @pixbuf.height
	end
end