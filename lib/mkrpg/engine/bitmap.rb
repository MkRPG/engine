require 'gtk2'

require_relative 'color'

Rect = Struct.new :x, :y, :width, :height

GDK_COLOR_SPACE_RGB = Gdk::Pixbuf::ColorSpace.new "rgb"

class Hash
	def reverse_merge(other_hash)
		other_hash.merge(self)
	end

	def reverse_merge!(other_hash)
		# right wins if there is no left
		merge!( other_hash ){|key,left,right| left }
	end
end

class Bitmap
	attr_reader :pixbuf
	attr_reader :height, :width

	def initialize(width, height)
		@pixbuf = Gdk::Pixbuf.new GDK_COLOR_SPACE_RGB, true, 8, width, height

		update_pixbuf
	end

	def initialize_with_pixbuf(pixbuf)
		@pixbuf = pixbuf

		update_pixbuf
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
		color = Color.new

		pixels = @pixbuf.pixels[pixel_pos(x, y), bytes]
		color.r = pixels.getbyte 0
		color.g = pixels.getbyte 1
		color.b = pixels.getbyte 2

		if pixbuf.has_alpha?
			color.a = pixels.getbyte 3
		end

		color
	end

	def []=(x, y, color)
		unless color.is_a? Color
			raise ArgumentError, 'New value is not a color'
		end

		pos = pixel_pos(x, y)
		@pixbuf.pixels[pos, bytes] = color.to_bstr

		color
	end

	def save
		0.upto width do |x|
			0.upto height do |y|
				save_pixel [ x, y ]
			end
		end
	end

	def crop(x, y, width = @width - x, height = @height - y)
		Bitmap.from_pixbuf crop_pixbuf(x, y, width, height)
	end

	def crop!(x, y, width, height)
		self.pixbf = crop_pixbuf(x, y, width, height)

		self
	end

	# def surface
	# 	require 'gtk2'

	# 	surface = Cairo::ImageSurface.new @width, @height

	# 	context = Cairo::Context.new surface

	# 	context.set_source_pixbuf @pixbuf
	# 	context.rectangle 0, 0, @width, @height
	# 	context.fill

	# 	surface
	# end

	def fill_rectangle(rect, color)
		bitmap = Bitmap.new(rect.width, rect.height)
		bitmap.fill color
		draw rect.x, rect.y, bitmap

		self
	end

	alias :fill_rect :fill_rectangle
	alias :rectangle :fill_rectangle
	alias :rect      :fill_rectangle

	def fill(color)
		@pixbuf.fill! ("0x" + color.to_bstr.bytes.to_a.map { |n| sprintf('%02X', n) }.join('')).hex
	end

	def draw_text(x, y, text, options = {})
		options = options.reverse_merge color: Color.new(0, 0, 0),
		                                font: "Ariel",
		                                style: :normal,
		                                size: 12


		layout = Pango::Layout.new Pango::Context.new
		layout.text = text

		font = Pango::FontDescription.new
		font.family = options[:font]
		font.style = case options[:style]
		             when :normal
		             	Pango::STYLE_NORMAL
		             when :bold
		             	Pango::STYLE_OBLIQUE
		             when :italic
		             	Pango::STYLE_ITALIC
		             end
		font.size = options[:size]

		layout.font_description = font

		pixmap = @pixbuf.render_pixmap_and_mask(127)[0]

		pixmap.draw_layout(Gdk::GC.new(pixmap), x, y, layout, options[:color].to_gdk)

		Gdk::Pixbuf.from_drawable nil, pixmap, 0, 0, *layout.pixel_size, @pixbuf, 0, 0

		self
	end
	alias :text :draw_text

	def draw(x, y, bitmap)
		pixbuf = get_pixbuf bitmap

		unless x > width  || x + pixbuf.width  <= 0
		       y > height || y + pixbuf.height <= 0
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

	def clear(color = Color.new(255, 255, 255))
		color_str = color.to_bstr
		@pixbuf.pixels = color_str * (@pixbuf.width * @pixbuf.height)

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
			raise "Cannot get pixbuf from #{o}"
		end
	end

	def crop_pixbuf(x, y, width, height)
		Gdk::Pixbuf.new @pixbuf, x, y, width, height
	end

	def pixel_pos(x, y)
		(x * bytes) + (y * @width * bytes)
	end

	def bytes
		@pixbuf.has_alpha? ? 4 : 3
	end

	def set_pixel(a, color)
		pixel_hash[a] = color
	end

	def update_pixbuf
		@width, @height = @pixbuf.width, @pixbuf.height
	end
end