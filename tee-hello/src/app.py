import os
import sys
import json

print('Started compute tee-hello')

iexec_out = os.environ['IEXEC_OUT']
result_file = iexec_out + '/result.txt'
computed_dot_json = iexec_out + '/computed.json'

iexec_out_dir = os.path.join(iexec_out)
if not os.path.exists(iexec_out_dir):
    os.makedirs(iexec_out_dir)

IEXEC = '''
  _ _____
 (_) ____|_  _____  ___ 
 | |  _| \ \/ / _ \/ __|
 | | |___ >  <  __/ (__ 
 |_|_____/_/\_\___|\___|

'''

name = "you"
if len(sys.argv) > 1:
    name = sys.argv[1]

with open(result_file, 'w+') as fout:
    result_txt = IEXEC + 'Hello from an enclave ' + name + '\n'
    fout.write(result_txt)
    print(result_txt)

with open(computed_dot_json, 'w+') as f:
    computed_json = { "deterministic-output-path" : result_file }
    json.dump(computed_json, f)
    print(computed_json)

print('Ended compute tee-hello')
