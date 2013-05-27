#
# Project's main unit test
#
# Copyright (C) 2013 Simon Rodwell
#
{Test, assert} = require('lovely')

describe "i18n", ->
  i18n = window = document = $ = null

  before Test.load (build, win)->
    i18n = build
    window   = win
    document = win.document
    $        = win.Lovely.module('dom')

  it "should have a version", ->
    assert.ok i18n.version

  it "should return the original key when no data is present", ->
    assert.equal("Ok", i18n("Ok"))

  it "should apply pluralisations even when no data is present", ->
    assert.equal("0 Comments", i18n("%n Comments", {num:0}))

  it "should apply formatting even when no data is present", ->
    assert.equal("Hi, Bob", i18n("Hi, <%name%>", {formatting:{name:"Bob"}}))

  describe "addData", ->
    it "should receive data containing values and/or contexts", ->
      i18n.addData({
        "values":[
          ["Yes", "はい"]
          ["No", "いいえ"]
          ["Welcome %name", "ようこそ %name"]
          [
            "%n comments"
            [
              [0, 0, "%n コメント"]
              [1, 1, "%n コメント"]
              [2, null, "%n コメント"]
            ]
          ]
          [
            "Due in %n days"
            [
              [null, -3, "-%n日前までに締め切り"]
              [-2, -2, "おとといまでに締め切り"]
              [-1, -1, "昨日までに締め切り"]
              [0, 0, "今日までに締め切り"]
              [1, 1, "明日までに締め切り"]
              [2, 2, "明後日までに締め切り"]
              [3, null, "%n日後までに締め切り"]
            ]
          ]
          ["<%name%> updated their profile", "<%name%>はプロフィールを更新し"]
        ],
        "contexts":[
          {
            "matches":{
              "gender":"male"
            },
            "values":[
              ["<%name%> updated their profile", "<%name%>は彼のプロフィールを更新し"]
              ["<%link%><%name%><%endLink%> updated their <%link%>profile<%endLink%>", "<%link%><%name%><%endLink%>は彼の<%link%>プロフィール<%endLink%>を更新し"]
            ]
          }
        ]
      })
    
    it "should receive data containing just values", ->
      i18n.addData({
        values:[
          ["Ok", "Ok"]
          ["Cancel", "キャンセル"]
        ]
      })

    it "should receive data containing just contexts", ->
      i18n.addData({
        contexts:[
          {
            "matches":{
              "gender":"female"
            }
            "values":[
              ["<%name%> updated their profile", "<%name%>は彼女のプロフィールを更新し"]
              ["<%link%><%name%><%endLink%> updated their <%link%>profile<%endLink%>", "<%link%><%name%><%endLink%>は彼女の<%link%>プロフィール<%endLink%>を更新し"]
            ]
          }
        ]
      })

    it "should translate simple text.", ->
      assert.equal("はい", i18n("Yes"))

    it "should use contexts when provided", ->
      assert.equal("Bobは彼のプロフィールを更新し", i18n("<%name%> updated their profile", {formatting:{name:"Bob"}, context:{gender:"male"}}))

    it "should use contexts when provided", ->
      assert.equal("Bobは彼のプロフィールを更新し", i18n("<%name%> updated their profile", {formatting:{name:"Bob"}, context:{gender:"male"}}))

    it "should default to the normal translations when no context is provided and global context is not set", ->
      assert.equal("Bobはプロフィールを更新し", i18n("<%name%> updated their profile", {formatting:{name:"Bob"}}))

    it "should default to the global context when no context is set", ->
      i18n.setContext("gender", "female")
      assert.equal("Janeは彼女のプロフィールを更新し", i18n("<%name%> updated their profile", {formatting:{name:"Jane"}}))

    it "should use the provided context to override the global", ->
      assert.equal("Bobは彼のプロフィールを更新し", i18n("<%name%> updated their profile", {formatting:{name:"Bob"}, context:{gender:"male"}}))

    it "should revert to the normal translation after the global context is cleared and no contexts are provided", ->
      i18n.clearContext("gender")
      assert.equal("Bobはプロフィールを更新し", i18n("<%name%> updated their profile", {formatting:{name:"Bob"}}))

    it "should translate all string properties in a given hash", ->
      hash = {
        ok: "Ok"
        cancel: "Cancel"
      }
      i18n.translateHash(hash)
      assert.equal(hash.cancel, "キャンセル")

    it "should ignore all non string properties in a given hash", ->
      hash = {
        number: 9
        arr: [1,2,3]
        obj:{foo:"bar"}
        ok: "Ok"
        cancel: "Cancel"
      }
      i18n.translateHash(hash)
      assert.equal(hash.cancel, "キャンセル")

    it "should go back to returning the key after the data has been reset", ->
      i18n.reset()
      assert.equal("Cancel", i18n("Cancel"))






