class @Service
  getMessageElement: -> throw new Exception 'abstraction method must be declared'
  addSwitchButtonElement: -> throw new Exception 'abstraction method must be declared'
  getSwitchButtonElement: -> $('#secure_switch')
  
  init: ->
    @addSwitchButtonElement()
    @bindEvents()

  initAfter: (ms) -> setTimeout @init, ms

  bindEvents: ->
    $('#secure_switch').bind 'click', => @toggleSecureElement()

  isSecured: -> @getMessageElement().hasClass 'secured'
  
  secureElement: ->
    @getMessageElement().addClass 'secured'
    @getSwitchButtonElement().text 'ON'
  unsecureElement: ->
    @getMessageElement().removeClass 'secured'
    @getSwitchButtonElement().text 'OFF'
  toggleSecureElement: -> if not @isSecured() then @secureElement() else @unsecureElement()