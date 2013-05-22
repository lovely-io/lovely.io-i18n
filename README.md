# i18n

A simple utility to help with the internationalisation of lovely.io projects.

It works by loading a language file that is specified in JSON

It has the following features:

* Keys for translation are specified in real English
* If the key value pair is not found it will default to the key (which is most often the correct English).
* Support for pluralisation
* Support for formatting text.
* Support for context sensitive translations e.g. gender specific.

## Usage

Install it locally with `lovely install i18n` or hook up from
`http://cdn.lovely.io`

    :javascript
    Lovely(['i18n'], function(i18n) {
      i18n.setLanguage("en", function(){
          console.log(i18n._("Hello World"))
      })
    });

## Example Language Files

### English

    :javascript
    {
      "values":[
        ["Hello World", "Hello World"],
        ["Yes", "Yes"],
        ["No", "No"]
      ]
    }

### Japanese

    :javascript
    {
      "values":[
        ["Hello World", "今日は世界"],
        ["Yes", "はい"],
        ["No", "いいえ"],
      ]
    }

Language files demonstrating more complex functionality can be downloaded here:

* [English](http://roddeh.com/i18n/en.json).
* [Japanese](http://roddeh.com/i18n/ja.json).

## Copyright And License

This project is released under the terms of the MIT license

Copyright (C) 2013 Simon Rodwell