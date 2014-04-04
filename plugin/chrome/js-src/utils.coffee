establishSecureConnection = ->
  message = @diffieHellman.handshake()
  # Send handshake and trace incoming handshake messages

encrypt = (message)->
  aesEncryptedMessage = CryptoJS.AES.encrypt message, @diffieHellman.shared_key
  @aesHumanizer.toNaturalString aesEncryptedMessage

decrypt = (message)->
  aesEncryptedMessage = @aesHumanizer.toAESString message
  CryptoJS.AES.decrypt aesEncryptedMessage, @diffieHellman.shared_key