import os

root                = 'iexec_out';
callbackFilePath    = '{}/callback.iexec'.format(root);

with open(callbackFilePath, 'wb+') as callbackFile:
    rand=os.getrandom(32,flags=0)
    callbackFile.write(rand)
    print(bin(int.from_bytes(rand,byteorder='big')))
