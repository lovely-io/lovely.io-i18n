#
# i18n main file
#
# Copyright (C) 2013 Simon Rodwell
#

con = console

# hook up dependencies
core    = require('core')
$       = require('dom')
ajax    = require('ajax')

# local variables assignments
Class   = core.Class
Element = $.Element
isArray = core.isArray

# glue in your files
include 'src/i18n'

# export your objects in the module
# exports.version = '%{version}'
# exports.loadLanguageFile = i18n.loadLanguageFile

# console.log({foo:i18n})

exports = i18n