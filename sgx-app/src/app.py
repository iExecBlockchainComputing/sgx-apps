
with open("/iexec_in/dataset.txt", "r") as fin:
   with open("/scone/result.txt", "w+") as fout:
       data = fin.read()
       fout.write(data)
       print(data)
