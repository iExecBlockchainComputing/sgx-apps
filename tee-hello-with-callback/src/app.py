import os
import sys
import json


print("Started compute tee-hello-with-callback")

iexec_out = os.environ['IEXEC_OUT']
computed_dot_json = iexec_out + '/computed.json'

iexec_out_dir = os.path.join(iexec_out)
if not os.path.exists(iexec_out_dir):
    os.mkdir(iexec_out_dir)

IEXEC = '''
  _ _____
 (_) ____|_  _____  ___ 
 | |  _| \ \/ / _ \/ __|
 | | |___ >  <  __/ (__ 
 |_|_____/_/\_\___|\___|

'''

hexChar = "a"

if len(sys.argv) > 1:
    hexChar = sys.argv[1]
callback_data = '0x000000000000000000000000000000000000000000000000000000000000000{}'.format(hexChar)

with open(computed_dot_json, 'w+') as fout:
    computed_json = { "callback-data" : callback_data}
    json.dump(computed_json, fout)
    print(computed_json)

print("Ended compute tee-hello-with-callback")
