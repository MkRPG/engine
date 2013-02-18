require_relative 'event_emitter'

class MapHash
	include EventEmitter

	def initialize(hash, get_proc, set_proc)
		@hash = hash
		@set_proc = set_proc
		@get_proc = get_proc
	end

	def [](*keys)
		@get_proc.call @hash[*keys], *keys
	end

	def []=(*keys, val)
		@hash[*keys] = @set_proc.call val, @hash[*keys], *keys
	end

	def has_key?(*keys)
		@hash.has_key? *keys
	end
end