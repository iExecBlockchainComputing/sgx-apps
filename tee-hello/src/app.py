import os
import sys
import json

print("Started compute tee-hello")

iexec_out = os.environ['IEXEC_OUT']
result_file = iexec_out + '/result.txt'
computed_json_file = iexec_out + '/computed.json'


dir = os.path.join(iexec_out)
if not os.path.exists(dir):
    os.makedirs(dir)

IEXEC = ' _\n(_)\n _  _____  _____  ___\n| |/ _ \ \/ / _ \/ __|\n| |  __/>  <  __/ (__\n|_|\___/_/\_\___|\___|\n\n'

with open(result_file, "w+") as fout:
    name = "you"
    if len(sys.argv) > 1:
        name = sys.argv[1]
    result_txt = IEXEC + "hello from an enclave " + name + "\n"
    fout.write(result_txt)
    print(result_txt)

# Return by writting 'computed.json' file at end of compute
with open(computed_json_file, "w+") as f:
    computed_json = { "deterministic-output-path" : result_file }
    json.dump(computed_json, f)
    print(computed_json)

print("Ended compute tee-hello")
