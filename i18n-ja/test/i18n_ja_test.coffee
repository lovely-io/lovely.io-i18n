#
# Project's main unit test
#
# Copyright (C) 2013 Simon Rodwell
#
{Test, assert} = require('lovely')

describe "i18nJa", ->
  i18n_ja = window = document = $ = null

  before Test.load (build, win)->
    i18n_ja = build
    window   = win
    document = win.document
    $        = win.Lovely.module('dom')

  it "should have a version", ->
    assert.ok i18n_ja.version

  it "should translate immediately", ->
    assert.equal(i18n_ja("Cancel"), "キャンセル")
