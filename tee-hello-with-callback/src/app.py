import os
import sys
from web3.auto import w3

keccak256 = w3.soliditySha3

print("Started compute tee-hello-with-callback")

dir = os.path.join("/scone/iexec_out")
if not os.path.exists(dir):
    os.mkdir(dir)

IEXEC = '\n _\n(_)\n _  _____  _____  ___\n| |/ _ \ \/ / _ \/ __|\n| |  __/>  <  __/ (__\n|_|\___/_/\_\___|\___|'

hexChar = "a"

if len(sys.argv) > 1:
    hexChar = sys.argv[1]

with open("/scone/iexec_out/callback.iexec", "w+") as fout:
   callback = '0x000000000000000000000000000000000000000000000000000000000000000{}'.format(hexChar)
   fout.write(callback)
   print('Callback: {} (written to callback.iexec)'.format(callback))
   digest = keccak256([ 'bytes' ], [ callback ]).hex()
   print('Digest: {} (not written, but should match reveal `resultDigest`)'.format(digest))

# touch 'completed-compute.iexec' file at end of compute
open('/scone/iexec_out/completed-compute.iexec', 'a').close()

print("Ended compute tee-hello-with-callback")
