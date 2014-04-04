DiffieHellman = ->

  privateKey = randBigInt(256)
  @shared_key = publicKey = otherPublicKey = p = g = undefined

  @handshake = (message)->
    if message == undefined
      p = str2bigInt "112457129983317064494133258034491756790943511028023366901014968560410379195027", 10, 80
      g = str2bigInt "3", 10, 80
    else
      p = str2bigInt(message.recievedP, 10, 80) unless p?
      g = str2bigInt(message.recievedG, 10, 80) unless g?
      otherPublicKey = message.publicKey
      @shared_key = bigInt2str powMod(otherPublicKey, privateKey, p), 10
    publicKey = bigInt2str(powMod(g, privateKey, p), 10)
    message =
      p: bigInt2str(p, 10)
      g: bigInt2str(g, 10)
      publicKey: publicKey
  return