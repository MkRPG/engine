module EventEmitter
	def on(event, &handler)
		if block_given?
			@_events ||= {}
			@_events[event] ||= []
			@_events[event] << handler
		end

		self
	end

	def emit(event, *args)
		if @_events && @_events[event]
			@_events[event].each do |handler|
				handler.call *args
			end
		end

		self
	end
end