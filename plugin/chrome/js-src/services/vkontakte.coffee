class Vkontakte extends Service
  getMessageElement: -> $('.im_editable_txt div.im_editable')
  addSwitchButtonElement: -> $('#im_user_holder').append '<div id="secure_switch"><i></i></div>'

  isReady: -> $('#im_texts').length > 0

  getMessagesElements: -> $('.im_msg_text')

  isOur: ($messageEl) ->
    $messageEl.siblings().find('a').attr('href') == $('#myprofile_wrap a').attr('href')

  send: (message) ->
    return false unless message?
    $('.im_editable_txt div.im_editable').text(message)
    $('button#im_send').click()

  secureElement: ->
    # button = $('button#im_send').clone()
    # button.attr 'id', 'im_send_fake'
    button = $('<button id="im_send_fake">Отправить</button>')

    # hide real button
    $('button#im_send').addClass 'faked'

    # add fake "Reply" button
    $(button).insertAfter $('button#im_send')

    # encrypt message wher user clicks on fake-Reply button
    $('#im_send_fake').click (e) =>
        e.preventDefault()
        e.stopPropagation()

        el = @getMessageElement()

        rawMessage = el.text()

        return false if !rawMessage

        encryptedMessage = @encryptMessage(rawMessage)

        el.text(encryptedMessage)
        # alert encryptedMessage

        $('button#im_send').click()
        false

    super

  unsecureElement: ->
    $('button#im_send_fake').remove()
    $('button#im_send').removeClass 'faked'
    super

(new Vkontakte).init()