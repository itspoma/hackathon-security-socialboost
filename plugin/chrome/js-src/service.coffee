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
      return true if @signature.isValid(message)
      if @signature.getType(message) == 'HANDSHAKE' && !diffieHellman.shared_key? && !@isOur $(messageEl)
        try
          message = JSON.parse message.substring(3)
        catch e
          message = undefined
        return true if message? && message.publicKey == diffieHellman.publicKey
        reply = diffieHellman.handshake(message) if message?
        @send reply
      else if @signature.getType(message) == 'MESSAGE'
        $(messageEl).text('MESSAGE')
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
    message.split('').reverse().join('')

  decryptMessage: (param1, param2) ->
    null

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