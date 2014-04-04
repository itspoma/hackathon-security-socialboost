class Odnoklassniki extends Service
  getMessageElement: -> $('#ok-e-m')
  addSwitchButtonElement: -> $('.gwt-RichTextToolbar').append '<div class="toolbarButton_w" id="secure_switch"><i></i></div>'

  secureElement: ->
    $('input[uid="uidClickSimpleInput"]').addClass 'secured'
    super

  unsecureElement: ->
    $('input[uid="uidClickSimpleInput"]').removeClass 'secured'
    super

(new Odnoklassniki).initAfter(10000)