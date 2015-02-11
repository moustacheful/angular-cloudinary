services.provider 'Cloudinary', ->
	provider = this
	
	abbreviatedAttr = (attr)->
		abbr = false
		switch attr
			when 'border' 
				abbr = 'bo'
			when 'page' 
				abbr = 'pg'
			when 'density' 
				abbr = 'dn'
			when 'flags' 
				abbr = 'fl'
			else 
				abbr = attr.substr(0,1)

		return abbr

	provider.localConfig = 
		https: false
	
	provider.presets =
		'default':
			format: 'jpg'

	provider.config = (configData)->
		provider.localConfig = configData
	
	provider.addPreset = (name,options)->
		provider.presets[name] = options
		
	provider.$get = ->
		addPreset: provider.addPreset

		get: (id,optionsOrPreset) ->
			if typeof optionsOrPreset == "string"
				if provider.presets[optionsOrPreset]?
					settings = provider.presets[optionsOrPreset]
				else
					settings = provider.presets['default']
			else
				settings = optionsOrPreset



			transform = []
			angular.forEach settings, (value,key) ->
				transform.push(abbreviatedAttr(key) + '_' + value)

			transform_str = ""
			if transform.length > 0
				transform_str = transform.join(',') + '/'
			
			protocol = if provider.localConfig.https then 'https://' else 'http://'

			built_str = "#{protocol}res.cloudinary.com/#{provider.localConfig.cloudName}/image/upload/#{transform_str}#{id}"
			
			return built_str
	
	return provider
