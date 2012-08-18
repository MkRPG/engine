class SceneTitle < Scene
	def initialize(game)
		super

		@options = Window::Options.new options: { new: 'New Game', continue: 'Continue',  quit: 'Quit' }

		@options.on(:select) do |opt|
			case opt
			when :new
				Game.map = Game.start_map

				Game.scene = SceneMap.new
			when :continue
				# TODO: Show Load Scene
			when :quit
				EM.stop
			end
		end

		@background = Sprite.new(Bitmap.from_file @game.title)
	end

	def start

	end

	def stop

	end
end