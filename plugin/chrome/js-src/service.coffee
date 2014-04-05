class @Service
  getMessageElement: -> throw new Exception 'abstraction method must be declared'
  getMessagesElements: -> throw new Exception 'abstraction method must be declared'
  addSwitchButtonElement: -> throw new Exception 'abstraction method must be declared'
  getSwitchButtonElement: -> $('#secure_switch')

  isReady: -> throw new Exception 'abstraction method must be declared'

  init: =>
    if !@isReady()
      setTimeout @init, 1000
      return

    @addSwitchButtonElement()
    @getSwitchButtonElement().addClass 'off'
    @bindEvents()
    @startMonitoring()
    @stopMonitoring()

  bindEvents: ->
    $('#secure_switch').bind 'click', => @toggleSecureElement()

  startMonitoring: =>
    @getMessagesElements().each (i,messageEl) =>
      message = $(messageEl).text()
      return true if !@signature.isValid(message)
      if @signature.getType(message) == 'HANDSHAKE' && !diffieHellman.shared_key? && !@isOur $(messageEl)
        try
          message = JSON.parse message.substring(3)
        catch e
          message = undefined
        return true if message? && message.publicKey == diffieHellman.publicKey
        reply = diffieHellman.handshake(message) if message?
        @send reply
      else if @signature.getType(message) == 'MESSAGE'
        res = @decryptMessage message
        $(messageEl).text(@decryptMessage message)

    @monitoring = setTimeout @startMonitoring, 2000

  stopMonitoring: => clearInterval(@monitoring) if @monitoring

  isSecured: -> @getMessageElement().hasClass 'secured'

  secureElement: ->
    @send diffieHellman.handshake()
    @getMessageElement().addClass 'secured'
    @getMessageElement().focus()
    el = @getSwitchButtonElement()
    el.removeClass 'on'
    el.removeClass 'off'
    el.addClass 'on'
    el.attr 'title', 'захищено'
    @startMonitoring()

  unsecureElement: ->
    @getMessageElement().removeClass 'secured'
    @getMessageElement().focus()
    el = @getSwitchButtonElement()
    el.removeClass 'on'
    el.removeClass 'off'
    el.addClass 'off'
    el.attr 'title', 'не захищено'
    @stopMonitoring()

  toggleSecureElement: -> if not @isSecured() then @secureElement() else @unsecureElement()

  encryptMessage: (message) ->
    aesEncryptedMessage = CryptoJS.AES.encrypt(message, diffieHellman.shared_key).toString()
    Service.prototype.signature.types.MESSAGE + aesHumanizer.toNaturalString aesEncryptedMessage

  decryptMessage: (message) ->
    message = message.substr Service.prototype.signature.types.MESSAGE.length
    aesEncryptedMessage = aesHumanizer.toAESString message
    CryptoJS.AES.decrypt(aesEncryptedMessage, diffieHellman.shared_key).toString(CryptoJS.enc.Utf8)

  signature:
    types:
      HANDSHAKE: '###'
      MESSAGE: '@@@'
    getType: (text) ->
      for key, value of this.types
        if (text.indexOf value) == 0
          return key
      null
    isValid: (text) -> this.getType(text)?
    format: (type, text) -> type + text

@AESHumanizer = ->

  nouns = ["frogs", "dogs", "eggnogs", "fogs", "logs", "cogs", "clogs", "balrogs",
    "polywogs", "groundhogs", "bogs", "grogs", "smogs", "backlogs", "catalogs",
    "warthogs"]
  verbs = ["enjoy", "detest", "juggle", "unearth", "devour", "fear", "debug",
    "debilitate", "accost", "toss", "greet", "conceptualize", "squeeze", "decapitate",
    "construct", "patronize"]
  conjunctions = ["and", "when", "whenever", "despite", "although", "but"]
  adverbs = ["also", "however", "unfortunately", "alternatively", "logically",
    "conversely", "sadly", "fortunately"]
  englishPhrase = undefined

  convertByteToNoun = (bytes) ->
    nouns[bytes]

  convertByteToVerb = (bytes) ->
    verbs[bytes]

  getAdverb = (bytes) ->
    index = Math.floor((bytes / 15) * (adverbs.length - 1))
    adverbs[index]

  getConjunction = (bytes) ->
    index = Math.floor((bytes / 15) * (conjunctions.length - 1))
    conjunctions[index]

  getSimplePhrase = (byte1, byte2, byte3) ->
    phrase = convertByteToNoun(byte1) + " "
    phrase += convertByteToVerb(byte2) + " "
    phrase += convertByteToNoun(byte3)
    phrase

  getCompoundPhrase = (aesStr, curIndex) ->
    phrase = getSimplePhrase(aesStr[curIndex], aesStr[curIndex + 1], aesStr[curIndex + 2])
    phrase += "; " + getAdverbPhrase(aesStr[curIndex + 3], aesStr[curIndex + 4], aesStr[curIndex + 5])
    phrase

  getAdverbPhrase = (byte1, byte2, byte3) ->
    getAdverb(byte1) + ", " + getSimplePhrase(byte1, byte2, byte3)

  getDoublePhrase = (aesStr, curIndex) ->
    phrase = ""
    phrase += getSimplePhrase(aesStr[curIndex], aesStr[curIndex + 1], aesStr[curIndex + 2]) + " "
    phrase += getConjunction(aesStr[curIndex + 3]) + " "
    phrase += getSimplePhrase(aesStr[curIndex + 3], aesStr[curIndex + 4], aesStr[curIndex + 5])
    phrase

  addPhrase = (aesStr, curIndex) ->
    increment = 3
    phrase = undefined
    if curIndex is 0
      phrase = getSimplePhrase(aesStr[curIndex], aesStr[curIndex + 1], aesStr[curIndex + 2])
    else
      currentByte = aesStr[curIndex]
      canCreateCompound = (aesStr.length - (curIndex + 8)) > 0
      if currentByte > 12 and canCreateCompound
        phrase = getCompoundPhrase(aesStr, curIndex)
        increment += 3
      else if currentByte > 12
        phrase = getAdverbPhrase(aesStr[curIndex], aesStr[curIndex + 1], aesStr[curIndex + 2])
      else if currentByte > 8 and canCreateCompound
        phrase = getDoublePhrase(aesStr, curIndex)
        increment += 3
      else if currentByte > 8
        phrase = getAdverbPhrase(aesStr[curIndex], aesStr[curIndex + 1], aesStr[curIndex + 2])
      else
        phrase = getSimplePhrase(aesStr[curIndex], aesStr[curIndex + 1], aesStr[curIndex + 2])

    #Capitalize and punctuate
    firstChar = phrase.charAt(0).toUpperCase()
    phrase = firstChar + phrase.substr(1) + ". "
    englishPhrase += phrase
    increment

  convertWordToByte = (word) ->
    word = word.toLowerCase()
    return -1  if conjunctions.indexOf(word) > 0
    return -1  if adverbs.indexOf(word) > 0
    index = nouns.indexOf(word)
    return index  if index >= 0
    index = verbs.indexOf(word)
    index

  strToCharCodes = (string) ->
    res = ""
    i = 0

    while i < string.length
      code = string.charCodeAt(i)
      codeLength = code.toString().length
      k = 0
      while k < 3 - codeLength
        code = "0" + code
        k++
      res = res + code
      i++
    res

  charCodesToStr = (string) ->
    res = ""
    i = 0
    while i < string.length
      res = res + String.fromCharCode(string[i] + string[i + 1] + string[i + 2])
      i = i + 3
    res

  @toNaturalString = (aesStr) ->
    aesCodesStr = strToCharCodes aesStr
    englishPhrase = ""
    maxLength = aesCodesStr.length
    leftOvers = maxLength % 3
    maxLength -= leftOvers
    i = 0

    while i < maxLength
      i += addPhrase(aesCodesStr, i)

    unless leftOvers == 0
      englishPhrase += "("
      while i < aesCodesStr.length
        englishPhrase += convertByteToNoun(aesCodesStr[i]) + " "
        i++
      englishPhrase += ")"
    englishPhrase

  @toAESString = (string) ->
    string = string.replace(/[\.,;\(\)]/g, "")
    words = string.split(" ")
    aesStr = []
    i = 0

    while i < words.length
      bytes = convertWordToByte(words[i]).toString()
      aesStr.push bytes if bytes >= 0
      i++
    res = charCodesToStr aesStr
    res

  return

@aesHumanizer = new AESHumanizer()