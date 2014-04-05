class Facebook extends Service
  getMessageElement: -> $('textarea[name="message_body"]')
  addSwitchButtonElement: ->
    $('#js_22 ._1rw ._211').prepend '<div id="secure_switch"><i></i></div>'
    # $('#js_22 ._1rw ._1r_[role="checkbox"]').hide()
    # $('#js_22 ._1rw ._1r-').css 'left','0'

  getMessagesElements: -> $('._3hi p')

  isReady: -> @getMessageElement().length >= 1

  secureElement: ->
    $('#js_22 ._2pt ._1rt').addClass 'secured'
    $('.uiToggle.emoticonsPanel').hide()
    $('#js_22 form#u_0_1h').hide()
    $('#js_22 ._2of').hide()
    super

  unsecureElement: ->
    $('#js_22 ._2pt ._1rt').removeClass 'secured'
    $('.uiToggle.emoticonsPanel').show()
    $('#js_22 form#u_0_1h').show()
    $('#js_22 ._2of').show()
    super

  bindEvents: ->
    # hide "Reply" button
    $('#js_22 ._1rw label.uiButtonConfirm').addClass 'faked'

    # add fake "Reply" button
    $('<label class="_1ri uiButton uiButtonConfirm" for="replay_fake"><input type="submit" value="Reply" id="replay_fake" class="_5f0v"></label>').insertAfter $('#js_22 ._1rw label.uiButtonConfirm')

    # encrypt message wher user clicks on fake-Reply button
    $('#replay_fake').click (e) =>
        rawMessage = $('.textMetrics').text().replace(/\.+$/, '')
        encryptedMessage = @encryptMessage(rawMessage)

        $('.textMetrics').html(encryptedMessage)

        $('#js_22 ._1rw label.uiButtonConfirm.faked input').click()
        false

    super

(new Facebook).init()