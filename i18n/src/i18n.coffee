#
# i18n main unit
#
# Copyright (C) 2013 Simon Rodwell
#

#
# Translates the supplied text based on the translation data that has been provided.
# Defaults to the text that was supplied if no matching translation can be found.
# @param {String} The text to be translated
# @param {Number} The number to be used for pluralisation
# @param {Object} Any replacements to be used when formatting the string
# @param {Object} An alternative context to be used in place of the globalContext.
# @returns {String} The translated and formatted string.
#
# i18n = (text, options = {}) ->
i18n = (text, num, formatting, context = @globalContext) ->
  if isObject(text)
    text = text['i18n'] if isObject(text['i18n'])
    i18n.translateHash(text, num, formatting, context)
  else
    i18n.translate(text, num, formatting, context)

i18n.globalContext = null
i18n.data = null

#
# Adds key/value pair data and contexts that are to be used when translating text.
#
# @param {Object} The language data:
# {
#   "values":[
#     "Yes":"はい"
#     "No":"いいえ"
#   ]
# }
# For a more complete example see: http://i18njs.com/i18n/ja.json
i18n.add = (d) ->
  if(d.values?)
    for k, v of d.values
      i18n.data.values[k] = v;
  if(d.contexts?)
    for c in d.contexts
      i18n.data.contexts.push(c)

#
# Sets the context globally.  This context will be used when translating all strings unless a different context is provided when calling i18n()
# @param {String} The key for the context e.g. "gender"
# @param {Mixed} The value for the context e.g. "female"
#
i18n.setContext = (key, value) ->
  i18n.globalContext[key] = value

#
# Clears the context for the given key
# @param {String} The key to clear
#
i18n.clearContext = (key) ->
  i18n.globalContext[key] = null

#
# Destroys all translation and context data.
#
i18n.reset = () ->
  i18n.data = {values:[], contexts:[]}
  i18n.globalContext = {}

#
# Destroys all translation data.  Useful for when you change languages
#
i18n.resetData = () ->
  i18n.data = {values:[], contexts:[]}

#
# Destroys all context data.
#
i18n.resetContext = () ->
  i18n.globalContext = {}

#
# Translates all the keys in a hash.  Useful for translating the i18n propety that exists for some lovely.io packages.
# @param {Object} Hash containing the strings to be translated
# @param {Object} Context to be used when translating the hash values
#
i18n.translateHash = (hash, context) ->
  hash[k] = i18n.translate(v, null, null, context) for k, v of hash when typeof v is "string"
  return hash

#
# Private
#
i18n.translate = (text, num, formatting, context = @globalContext) ->
  data = i18n.data
  # If we have failed to find any language data simply use the supplied text.
  return i18n.useOriginalText(text, num, formatting) unless data?
  # Try to get a result using the current context
  contextData = i18n.getContextData(data, context)
  result = i18n.findTranslation(text, num, formatting, contextData.values) if contextData?
  # If we didn't get a result with the context then use the non-contextual values
  result = i18n.findTranslation(text, num, formatting, data.values) unless result?
  # If we still didn't get a result then use the original text
  return i18n.useOriginalText(text, num, formatting) unless result?
  # Otherwise we got a result so lets use it.
  return result

i18n.findTranslation = (text, num, formatting, data) ->
  value = data[text]
  return null unless value?
  unless num?
    return i18n.applyFormatting(value, num, formatting) if typeof value is "string"
  else
    if (value instanceof Array)
      for triple in value
        if((num >= triple[0] || triple[0] is null) and (num <= triple[1] || triple[1] is null))
          result = i18n.applyFormatting(triple[2].replace("-%n", String(-num)), num, formatting)
          return i18n.applyFormatting(result.replace("%n", String(num)), num, formatting)
  return null

i18n.getContextData = (data, context) ->
  return null unless data.contexts?
  for c in data.contexts
    equal = true
    for key, value of c.matches
      equal = equal and value is context[key]
    return c if equal
  return null

i18n.useOriginalText = (text, num, formatting) ->
  return i18n.applyFormatting(text, num, formatting) unless num?
  return i18n.applyFormatting(text.replace("%n", String(num)), num, formatting)

i18n.applyFormatting = (text, num, formatting) ->
  for ind of formatting
    # regex = new RegExp("<%#{ ind }%>", "g")
    regex = new RegExp("%{#{ ind }}", "g")
    text = text.replace(regex, formatting[ind])
  return text;
