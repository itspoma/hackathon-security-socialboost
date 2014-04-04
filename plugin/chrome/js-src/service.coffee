class @Service
  getMessageElement: -> throw new Exception 'abstraction method must be declared'
  addSwitchButtonElement: -> throw new Exception 'abstraction method must be declared'
  getSwitchButtonElement: -> $('#secure_switch')
  
  init: =>
    @addSwitchButtonElement()
    @getSwitchButtonElement().addClass 'off'
    @bindEvents()

  initAfter: (ms) ->
    setTimeout @init, ms

  bindEvents: ->
    $('#secure_switch').bind 'click', => @toggleSecureElement()

  isSecured: -> @getMessageElement().hasClass 'secured'
  
  secureElement: ->
    @getMessageElement().addClass 'secured'
    el = @getSwitchButtonElement()
    el.removeClass 'on'
    el.removeClass 'off'
    el.addClass 'on'
    el.attr 'title', 'захищено'
  unsecureElement: ->
    @getMessageElement().removeClass 'secured'
    el = @getSwitchButtonElement()
    el.removeClass 'on'
    el.removeClass 'off'
    el.addClass 'off'
    el.attr 'title', 'не захищено'
  toggleSecureElement: -> if not @isSecured() then @secureElement() else @unsecureElement()

  encryptMessage: (message) ->
    message.split('').reverse().join('')

  decryptMessage: (param1, param2) ->
    null