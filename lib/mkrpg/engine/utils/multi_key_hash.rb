require_relative 'event_emitter'

class MultiKeyHash
	include EventEmitter

	def initialize
		@hash = {}
	end

	def [](*keys)
		@hash[keys]
	end

	def []=(*keys, val)
		emit 'set', keys, val
		@hash[keys] = val
	end

	def has_key?(*keys)
		@hash.has_key? keys
	end
end