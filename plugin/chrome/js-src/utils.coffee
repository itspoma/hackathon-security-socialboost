encrypt = (message)->
  aesEncryptedMessage = CryptoJS.AES.encrypt message, @diffieHellman.shared_key
  @aesHumanizer.toNaturalString aesEncryptedMessage

decrypt = (message)->
  aesEncryptedMessage = @aesHumanizer.toAESString message
  CryptoJSAES.decrypt aesEncryptedMessage, @diffieHellman.shared_key