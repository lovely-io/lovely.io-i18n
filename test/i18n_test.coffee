#
# Project's main unit test
#
# Copyright (C) 2013 Simon Rodwell
#
{Test, assert} = require('lovely')

describe "I18n", ->
  I18n = window = document = $ = null

  before Test.load (build, win)->
    I18n = build
    window   = win
    document = win.document
    $        = win.Lovely.module('dom')

  it "should have a version", ->
    assert.ok I18n.version

