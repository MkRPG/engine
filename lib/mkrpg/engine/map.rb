require_relative 'utils/multi_key_hash'
require_relative 'utils/map_hash'

module MkRPG
	module Engine
		class Map
			attr_accessor :name
			attr_accessor :game
			attr_reader :tile_ids, :tiles
			attr_reader :events

			def initialize(name = nil)
				@name = name ? name.to_s : name
				@tile_ids = MultiKeyHash.new
				@tiles = MapHash.new(@tile_ids, proc {  |val, *keys| @game.tilesets[val[0]][val[1], val[2]] },
				                                proc do |new_val, old_val, *keys|
				                                	@game.add_tileset new_val.tileset
				                                	[ @game.tilesets.index(new_val.tileset), new_val.x, new_val.y ]
				                                end)
			end
		end
	end
end