import os

root                = 'iexec_out';
callbackFilePath    = '{}/callback.iexec'.format(root);

with open(callbackFilePath, 'wb+') as callbackFile:
    callbackFile.write(os.getrandom(4,flags=0))
