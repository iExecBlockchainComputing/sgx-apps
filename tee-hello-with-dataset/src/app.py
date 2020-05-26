import os
import json

print("Started compute tee-hello-with-dataset")

iexec_out = os.environ['IEXEC_OUT']
dataset_file = os.environ['IEXEC_IN'] + '/dataset.txt'
result_file = iexec_out + '/result.txt'
computed_json_file = iexec_out + '/computed.json'

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

with open(dataset_file, 'r') as fin:
   with open(result_file, "w+") as fout:
        dataset_content = fin.read()
        result_txt = IEXEC + ' Hello from an enclave' + "\n" + 'dataset content: ' + dataset_content
        fout.write(result_txt)
        print(result_txt)

with open(computed_json_file, 'w+') as f:
    computed_json = { "deterministic-output-path" : result_file }
    json.dump(computed_json, f)
    print(computed_json)

print("Ended compute tee-hello-with-dataset")
