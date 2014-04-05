@DiffieHellman = ->

  privateKey = randBigInt(256)
  # Temporary decision to finish up all other parts of the program. Should be undefined.
  @shared_key = "60608010726750674192959028589795515072625428377410239241325139187046406995695"
  @publicKey = otherPublicKey = p = g = undefined

  @handshake = (message)->
    return undefined if @shared_key?

    if message == undefined
      p = str2bigInt "112457129983317064494133258034491756790943511028023366901014968560410379195027", 10, 80
      g = str2bigInt "3", 10, 80
      @publicKey = bigInt2str(powMod(g, privateKey, p), 10)
      message =
        p: bigInt2str(p, 10)
        g: bigInt2str(g, 10)
        publicKey: @publicKey
    else
      message = JSON.stringify(message.substr Service.prototype.signature.types.HANDSHAKE.length + 1)
      if message.p != undefined && message.g != undefined
        p = str2bigInt(message.p, 10, 80)
        g = str2bigInt(message.g, 10, 80)
        otherPublicKey = message.publicKey
        @shared_key = bigInt2str powMod(otherPublicKey, privateKey, p), 10
        message =
          publicKey: @publicKey
      else
        @shared_key = bigInt2str powMod(otherPublicKey, privateKey, p), 10
        message = undefined
    console.log @shared_key
    if message?
      Service.prototype.signature.types.HANDSHAKE + JSON.stringify(message)
    else
      undefined

  return

@diffieHellman = new DiffieHellman()