class Vkontakte extends Service
  getMessageElement: -> $('.im_editable_txt div.im_editable')
  addSwitchButtonElement: -> $('#im_user_holder').append '<div id="secure_switch"><i></i></div>'

(new Vkontakte).init()