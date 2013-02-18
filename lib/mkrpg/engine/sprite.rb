class Sprite
	attr_reader :game
	attr_reader :bitmap
	attr_accessor :x, :y

	def initialize(game, bitmap = nil, height = nil, options = {})
		@game = game
		if bitmap.is_a? Bitmap
			@bitmap = bitmap
		else
			@bitmap = Bitmap.new(bitmap, height)
		end

		@x = @y = 0

		@persistent = !!(options.has_key?(:persistent) ? options[:persistent] : false)
	end

	attr_writer :persistent
	def persistent;     @persistent = true;  self; end
	def not_persistent; @persistent = false; self; end
	def persistent?;    @persistent;               end
end