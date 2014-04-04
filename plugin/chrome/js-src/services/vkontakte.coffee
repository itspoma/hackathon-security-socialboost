class Vkontakte extends Service
  getMessageElement: -> $('.im_editable_txt div.im_editable')
  addSwitchButtonElement: -> $('#im_user_holder').append '<div id="secure_switch">11</div>'

(new Vkontakte).init()