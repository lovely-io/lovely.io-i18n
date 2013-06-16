#
# i18n main file
#
# Copyright (C) 2013 Simon Rodwell
#

# hook up dependencies
core    = require('core')

# local variables assignments
Class    = core.Class
isArray  = core.isArray
isObject = core.isObject

# glue in your files
include 'src/i18n'

i18n.reset()
exports = i18n
exports.version = '%{version}'
