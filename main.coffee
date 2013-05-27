#
# i18n main file
#
# Copyright (C) 2013 Simon Rodwell
#

# hook up dependencies
core    = require('core')

# local variables assignments
Class   = core.Class
isArray = core.isArray

# glue in your files
include 'src/i18n'

# export your objects in the module
exports.version = '%{version}'

exports = i18n