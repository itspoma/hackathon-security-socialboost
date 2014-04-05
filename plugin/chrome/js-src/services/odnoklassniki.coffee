class Odnoklassniki extends Service
  getMessageElement: -> $('#ok-e-m')
  addSwitchButtonElement: -> $('.gwt-RichTextToolbar').append '<div class="toolbarButton_w" id="secure_switch"><i></i></div>'

  getMessagesElements: -> $('.d_comment_w .d_comment_right_w .d_comment_text')

  isReady: -> $('.mdialog_chat_conversation_cnt').length >= 1

  secureElement: ->
    button = $('<div class="disc_text_area_button" id="ok-e-m_button-fake"><span class="disc_text_area_button_label">Отправить</span><span class="disc_text_area_button_label__loading">загрузка</span></div>')

    # hide real button
    $('#ok-e-m_button').addClass 'faked'

    # add fake "Reply" button
    $(button).insertAfter $('#ok-e-m_button')

    # encrypt message wher user clicks on fake-Reply button
    $('#ok-e-m_button-fake').click (e) =>
        e.preventDefault()
        e.stopPropagation()

        el = @getMessageElement()

        rawMessage = el.text()

        return false if !rawMessage

        encryptedMessage = @encryptMessage(rawMessage)

        el.text(encryptedMessage)

        $('#ok-e-m_button').click()

        e = $.Event('keypress')
        e.which = 13
        el.trigger(e)

        false

    $('input[uid="uidClickSimpleInput"]').addClass 'secured'
    $('[uid="callVMailFromComments"]').hide()
    $('.nimTextAreaformatButton').addClass 'opacity0'
    $('.nimTextAreasmilesButton_2').addClass 'opacity0'
    $('.nimTextAreasmilesButton_6').addClass 'opacity0'
    super

  unsecureElement: ->
    $('#ok-e-m_button-fake').remove()
    $('#ok-e-m_button').removeClass 'faked'

    $('input[uid="uidClickSimpleInput"]').removeClass 'secured'
    $('[uid="callVMailFromComments"]').show()
    $('.nimTextAreaformatButton').removeClass 'opacity0'
    $('.nimTextAreasmilesButton_2').removeClass 'opacity0'
    $('.nimTextAreasmilesButton_6').removeClass 'opacity0'
    super

(new Odnoklassniki).init()