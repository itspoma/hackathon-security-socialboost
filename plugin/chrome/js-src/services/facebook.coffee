class Facebook extends Service
  getMessageElement: -> $('textarea[name="message_body"]')
  addSwitchButtonElement: -> $('#js_22 ._1rw ._211').prepend '<div id="secure_switch"><i></i></div>'

  secureElement: ->
    $('#js_22 ._2pt ._1rt').addClass 'secured'
    super

  unsecureElement: ->
    $('#js_22 ._2pt ._1rt').removeClass 'secured'
    super

(new Facebook).initAfter(5000)