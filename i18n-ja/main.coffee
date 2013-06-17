#
# I18nJa main file
#
# Copyright (C) 2013 Simon Rodwell
#

core = require('core')
i18n = require('i18n')

i18n.add(
  values:
    Yes: "はい",
    No: "いいえ",
    Ok: "Ok",
    Cancel: "キャンセル"
, "ja")

i18n_ja = ->
  args = [arguments[0]]
  args[1] = "ja"
  for a in [2 .. arguments.length]
    args.push(arguments[a])
  i18n.apply(i18n, args)

exports = i18n_ja
exports.version = '%{version}'
