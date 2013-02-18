module MkRPG
	module Engine
		autoload :Game, File.expand_path('engine/game', __FILE__)
		autoload :Map, File.expand_path('engine/map', __FILE__)
	end
end