#
# The Russian translations package
#
# Copyright (C) 2013 Nikolay Nemshilov
#
core = require('core')
i18n = require('i18n')

i18n.add 'ru',

  Ok:     '',
  Okay:   '',
  Save:   '',
  Cancel: ''


i18n_ru = ->
  i18n.lang = 'ru'
  i18n.apply(i18, arguments)

i18n_ru.version = "%{version}"

exports = i18n_ru
