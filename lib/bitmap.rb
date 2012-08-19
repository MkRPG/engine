require 'gtk2'

require_relative 'color'

Rect = Struct.new "Rect", :x, :y, :w, :h

GDK_COLOR_SPACE_RGB = Gdk::Pixbuf::ColorSpace.new "rgb"

class Bitmap
	attr_reader :pixbuf
	attr_reader :height, :width

	def initialize(width, height)
		@pixbuf = Gdk::Pixbuf.new GDK_COLOR_SPACE_RGB, true, 8, width, height

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

	def crop(x, y, width = @width, height = @height)
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

	def draw(x, y, bitmap)
		pixbuf = get_pixbuf bitmap

		unless x > width  ||
		       y > height
			draw_x, draw_y = x, y
			part_x = part_y = 0

			if draw_x < 0
				part_x = -draw_x
				draw_x = 0
			end
			if draw_y < 0
				part_y = -draw_y
				draw_y = 0
			end

			draw_width = @width - draw_x
			draw_height = @height - draw_y

			draw_width = pixbuf.width if draw_width > pixbuf.width
			draw_height = pixbuf.height if draw_height > pixbuf.height

			draw_width -= part_x
			draw_height -= part_y

			pixbuf.copy_area part_x, part_y, draw_width, draw_height, @pixbuf, draw_x, draw_y
		end

		self
	end

	def clear(color = 255)
		color_str = ' '
		color_str.setbyte 0, color
		@pixbuf.pixels = color_str * (@pixbuf.width * @pixbuf.height * (@pixbuf.has_alpha? ? 4 : 3))

		self
	end

private
	
	def get_pixbuf(o)
		if o.is_a?(Bitmap) || o.respond_to?(:pixbuf)
			get_pixbuf o.pixbuf
		elsif o.is_a?(Gdk::Pixbuf)
			o
		elsif o.respond_to?(:bitmap)
			get_pixbuf o.bitmap
		else
			raise "Cannot get pixbuf from #{o.class}"
		end
	end

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