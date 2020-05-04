import os
import sys

print("Started compute tee-hello")

PROTECTED_IEXEC_OUT = "/scone/iexec_out";

dir = os.path.join(PROTECTED_IEXEC_OUT)
if not os.path.exists(dir):
    os.mkdir(dir)

IEXEC = ' _\n(_)\n _  _____  _____  ___\n| |/ _ \ \/ / _ \/ __|\n| |  __/>  <  __/ (__\n|_|\___/_/\_\___|\___|\n\n'

with open(PROTECTED_IEXEC_OUT + "/result.txt", "w+") as fout:

    name = "you"

    if len(sys.argv) > 1:
        name = sys.argv[1]

    resultTxt = IEXEC + "hello from an enclave " + name + "\n"

    fout.write(resultTxt)
    print(resultTxt)


# touch 'completed-compute.iexec' file at end of compute
open(PROTECTED_IEXEC_OUT + '/completed-compute.iexec', 'a').close()

print("Ended compute tee-hello")
