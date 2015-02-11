(function() {
  var filters, main, services;

  main = angular.module('Cloudinary', ['Cloudinary.filters', 'Cloudinary.services']);

  services = angular.module('Cloudinary.services', []);

  filters = angular.module('Cloudinary.filters', []);

  filters.filter('cloudinary', function(Cloudinary) {
    return function(publicId, options) {
      return Cloudinary.get(publicId, options);
    };
  });

  services.provider('Cloudinary', function() {
    var abbreviatedAttr, provider;
    provider = this;
    abbreviatedAttr = function(attr) {
      var abbr;
      abbr = false;
      switch (attr) {
        case 'border':
          abbr = 'bo';
          break;
        case 'page':
          abbr = 'pg';
          break;
        case 'density':
          abbr = 'dn';
          break;
        case 'flags':
          abbr = 'fl';
          break;
        default:
          abbr = attr.substr(0, 1);
      }
      return abbr;
    };
    provider.localConfig = {
      https: false
    };
    provider.presets = {
      'default': {
        format: 'jpg'
      }
    };
    provider.config = function(configData) {
      return provider.localConfig = configData;
    };
    provider.addPreset = function(name, options) {
      return provider.presets[name] = options;
    };
    provider.$get = function() {
      return {
        addPreset: provider.addPreset,
        get: function(id, optionsOrPreset) {
          var built_str, protocol, settings, transform, transform_str;
          if (typeof optionsOrPreset === "string") {
            if (provider.presets[optionsOrPreset] != null) {
              settings = provider.presets[optionsOrPreset];
            } else {
              settings = provider.presets['default'];
            }
          } else {
            settings = optionsOrPreset;
          }
          transform = [];
          angular.forEach(settings, function(value, key) {
            return transform.push(abbreviatedAttr(key) + '_' + value);
          });
          transform_str = "";
          if (transform.length > 0) {
            transform_str = transform.join(',') + '/';
          }
          protocol = provider.localConfig.https ? 'https://' : 'http://';
          built_str = protocol + "res.cloudinary.com/" + provider.localConfig.cloudName + "/image/upload/" + transform_str + id;
          return built_str;
        }
      };
    };
    return provider;
  });

}).call(this);
