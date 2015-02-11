filters.filter 'cloudinary', (Cloudinary)->
	(publicId,options) ->
		return Cloudinary.get(publicId,options)