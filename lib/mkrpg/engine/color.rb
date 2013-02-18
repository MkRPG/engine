class Color
	attr_accessor :a
	attr_accessor :r, :g, :b

	def initialize(r = 0, g = 0, b = 0, a = 255)
		@a = a

		@r = r
		@g = g
		@b = b
	end

	# def h; hsv[0]; end
	# def s; hsv[1]; end
	# def v; hsv[2]; end

	def rgb; [ @r, @g, @b ]; end
	def rgba; rgb + [ @a ]; end

	# def hsva; hsv + [ @a ]; end
	# def hsv
	# 	r = @r / 255.0
	# 	g = @g / 255.0
	# 	b = @b / 255.0
	# 	max = [r, g, b].max
	# 	min = [r, g, b].min
	# 	delta = max - min
	# 	v = max * 100

	# 	if max != 0.0
	# 		s = delta / max *100
	# 	else
	# 		s = 0.0
	# 	end

	# 	if s == 0.0
	# 		h = 0.0
	# 	else
	# 		if r == max
	# 			h = (g - b) / delta
	# 		elsif g == max
	# 			h = 2 + (b - r) / delta
	# 		elsif b == max
	# 			h = 4 + (r - g) / delta
	# 		end

	# 		h *= 60.0

	# 		if h < 0
	# 			h += 360.0
	# 		end
	# 	end

	# 	[ h, s, v ]
	# end

	def to_bstr
		str = "    "
		str.encode! Encoding.find("ASCII-8BIT")
		str.setbyte 0, @r
		str.setbyte 1, @g
		str.setbyte 2, @b
		str.setbyte 3, @a
		str
	end

	def to_gdk
		Gdk::Color.new @r, @b, @g
	end
end