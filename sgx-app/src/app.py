import os

print("Started compute tee-hello-with-dataset")

dir = os.path.join("/scone/iexec_out")
if not os.path.exists(dir):
    os.mkdir(dir)

IEXEC = '\n _\n(_)\n _  _____  _____  ___\n| |/ _ \ \/ / _ \/ __|\n| |  __/>  <  __/ (__\n|_|\___/_/\_\___|\___|'

with open("/iexec_in/dataset.txt", "r") as fin:
   with open("/scone/iexec_out/result.txt", "w+") as fout:

       datasetContent = fin.read()
       resultTxt = IEXEC + ' hello from an enclave' + "\n" + 'dataset content: ' + datasetContent

       fout.write(resultTxt)
       print(resultTxt)
       

# touch 'completed-compute.iexec' file at end of compute
open('/scone/iexec_out/completed-compute.iexec', 'a').close()

print("Ended compute tee-hello-with-dataset")
