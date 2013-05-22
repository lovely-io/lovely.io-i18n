#
# i18n main unit
#
# Copyright (C) 2013 Simon Rodwell
#

class i18n

  extend:

    currentLanguage: null
    globalContext:{}
    packages:{}

    # Default object to handle the "global" package for the application
    appPackage:
      details:
        name: null      
        languageFilePath: "/i18n/"
        supportsLanguage: () -> return true
        handleLanguageChange: () -> return false
      data: null


    setLanguage: (languageCode, callback) ->
      @currentLanguage = languageCode
      @loadLanguageFile(@appPackage, @currentLanguage, callback)
      for pkg in @packages
        loadLanguageFile(pkg, @currentLanguage, pkg.details.handleLanguageChange)

    addPackage: (pkg) ->
      @packages[pkg.name] = {
        details:pkg,
        data: null
      }
      loadLanguageFile(pkg, @currentLanguage, pkg.handleLanguageChange) if (@currentLanguage?)

    removePackage: (pkg) ->
      @packages[pkg.name] = null

    #
    # Loads a language file 
    #
    # @param {String} The language code for the language file that you would like to load
    # @param {String} Callback when the language file has loaded or fails to load
    # @param {String} A default language to fall back to if the first language fails
    #
    loadLanguageFile: (pkg, languageCode, callback) ->
      ajax.get("#{ pkg.details.languageFilePath + languageCode }.json", {
        success: (response) =>
          data = response.ajax.responseJSON
          con.log("data", data)
          # @data = data.values
          # @contexts = data.contexts
          pkg.data = data
          callback(@) if callback?
        failure: () =>
          # if defaultLanguage? and languageCode != defaultLanguage
            # @loadLanguageFile(defaultLanguage, callback)
          # else
          console.error("Unable to load the specified language or the default language")
            # @data = null
            # @contexts = null
          callback(@)
      })

    #
    # Translates the given text to the language that has been loaded.
    #
    # @param {String} The text to be translated
    # @param {Number} The number to be used in case of pluralisation
    # @param {Object} Set of key value pairs to be interpolated into the text
    # @param {Object} Set of key value pairs to provide the context when translating
    #
    _: (text, num, formatting, context = @globalContext, packageName) ->
      # Use the global data
      pkg = @packages[packageName] if packageName?
      pkg = @appPackage unless pkg?
      data = pkg.data
      # If we have failed to find any language data simply use the supplied text.
      return @useOriginalText(text, num, formatting) unless data?
      # Try to get a result using the current context
      contextData = @getContextData(data, context)
      # con.log(contextData)
      result = @__(text, num, formatting, contextData.values) if contextData?
      # If we didn't get a result with the context then use the non-contextual values
      result = @__(text, num, formatting, data.values) unless result?
      # If we still didn't get a result then use the original text
      return @useOriginalText(text, num, formatting) unless result?
      # Otherwise we got a result so lets use it.
      return result

    #
    # Sets the global context for a given key
    #
    # @param {String} Key for the context you are setting
    # @param {String} Value for the context you are setting
    # 
    setContext: (context, value) ->
      @globalContext[context] = value

    #
    # Sets the global context for a given key
    #
    # @param {String} Key for the context you are setting
    # 
    clearContext: (context) ->
      @globalContext[context] = null  

    # private 

    __: (text, num, formatting, data) ->
      # If we have a complete data set then lets find the correct translation.
      for pair in data
        return null unless pair?
        if pair[0] is text
          unless num?
            return @applyFormatting(pair[1], num, formatting) if typeof pair[1] is "string"
          else
            if isArray(pair[1])
              for triple in pair[1]
                if((num >= triple[0] || triple[0] is null) and (num <= triple[1] || triple[1] is null))
                  result = @applyFormatting(triple[2].replace("-%n", String(-num)), num, formatting)
                  return @applyFormatting(result.replace("%n", String(num)), num, formatting)
      return null

    getContextData: (data, context) ->
      return null unless data.contexts?
      for c in data.contexts
        equal = true
        for key, value of c.matches
          equal = equal and value is context[key]
        return c if equal
      return null

    useOriginalText: (text, num, formatting) ->
      return @applyFormatting(text, num, formatting) unless num?
      return @applyFormatting(text.replace("%n", String(num)), num, formatting)

    applyFormatting: (text, num, formatting) ->
      for ind of formatting
        regex = new RegExp("<%#{ ind }%>", "g")
        text = text.replace(regex, formatting[ind])
      return text;

  constructor: () ->
    throw new Error("i18n is designed to work as a singleton.")

  # return @
