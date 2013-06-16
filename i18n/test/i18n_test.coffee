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
    assert.equal(i18n("Ok"), "Ok")

  it "should apply pluralisations even when no data is present", ->
    assert.equal(i18n("%n Comments", 0), "0 Comments")

  it "should apply formatting even when no data is present", ->
    assert.equal(i18n("Hi, %{name}", {name:"Bob"}), "Hi, Bob")

  describe "add", ->
    it "should receive data containing values and/or contexts", ->
      i18n.add({
        "values":{
          "Yes": "はい",
          "No": "いいえ",
          "Welcome %{name}": "ようこそ %{name}",
          "%n comments":[
            [0, 0, "%n コメント"],
            [1, 1, "%n コメント"],
            [2, null, "%n コメント"]
          ],
          "Due in %n days":[
            [null, -3, "-%n日前までに締め切り"],
            [-2, -2, "おとといまでに締め切り"],
            [-1, -1, "昨日までに締め切り"],
            [0, 0, "今日までに締め切り"],
            [1, 1, "明日までに締め切り"],
            [2, 2, "明後日までに締め切り"],
            [3, null, "%n日後までに締め切り"]
          ],
          "%{name} updated their profile": "%{name}はプロフィールを更新し",
        },
        "contexts":[
          {
            "matches":{
              "gender":"male"
            },
            "values":{
              "%{name} updated their profile": "%{name}は彼のプロフィールを更新し",
              "%{link}%{name}%{endLink} updated their %{link}profile%{endLink}": "%{link}%{name}%{endLink}は彼の%{link}プロフィール%{endLink}を更新し",
              "%{name} added %n photos to their album":[
                [0, null, "%{name}は彼のアルバムに写真%n枚を追加しました"]
              ]
            }
          }
        ]
      })

    it "should receive data containing just values", ->
      i18n.add({
        values:{
          "Ok": "Ok",
          "Cancel": "キャンセル"
        }
      })

    it "should receive data containing just contexts", ->
      i18n.add({
        contexts:[
          {
            "matches":{
              "gender":"female"
            },
            "values":{
              "%{name} updated their profile": "%{name}は彼女のプロフィールを更新し",
              "%{link}%{name}%{endLink} updated their %{link}profile%{endLink}": "%{link}%{name}%{endLink}は彼女の%{link}プロフィール%{endLink}を更新し"
            }
          }
        ]
      })

    it "should translate simple text.", ->
      assert.equal(i18n("Yes"), "はい")

    it "should use contexts when provided", ->
      assert.equal(i18n("%{name} updated their profile", {name:"Bob"}, {gender:"male"}), "Bobは彼のプロフィールを更新し")

    it "should default to the normal translations when no context is provided and global context is not set", ->
      assert.equal(i18n("%{name} updated their profile", {name:"Bob"}), "Bobはプロフィールを更新し")

    it "should default to the global context when no context is set", ->
      i18n.setContext("gender", "female")
      assert.equal(i18n("%{name} updated their profile", {name:"Jane"}), "Janeは彼女のプロフィールを更新し")

    it "should use the provided context to override the global", ->
      assert.equal(i18n("%{name} updated their profile", {name:"Bob"}, {gender:"male"}), "Bobは彼のプロフィールを更新し")

    it "should revert to the normal translation after the global context is cleared and no contexts are provided", ->
      i18n.clearContext("gender")
      assert.equal(i18n("%{name} updated their profile", {name:"Bob"}), "Bobはプロフィールを更新し")

    it "should handle the case of pluralisation, formatting and context.", ->
      # i18n.add({
      #   contexts:[
      #     {
      #       "matches":{
      #         "gender":"male"
      #       },
      #       "values":{
      #         "%{name} added %n photos to their album": "%{name}は彼のアルバムに写真%n枚を追加しました",
      #       }
      #     }
      #   ]
      # })

      console.log("--***********-------")
      console.log( i18n("%{name} added %n photos to their album", 6, {name:"Bob"}, {gender:"male"}))
      console.log("--***********-------")
      assert.equal(i18n("%{name} added %n photos to their album", 6, {name:"Bob"}, {gender:"male"}), "Bobは彼のアルバムに写真6枚を追加しました")


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

    it "should translate hashes straight away", ->
      hash = {
        ok: "Ok"
        cancel: "Cancel"
      }
      i18n(hash)
      assert.equal(hash.cancel, "キャンセル")

    it "should recognize the i18n keys on the hashes", ->
      Widget = {
        i18n: {
          ok: "Ok"
          cancel: "Cancel"
        }
      }
      i18n(Widget)
      assert.equal(Widget.i18n.cancel, "キャンセル")

    it "should go back to returning the key after the data has been reset", ->
      i18n.reset()
      assert.equal("Cancel", i18n("Cancel"))






