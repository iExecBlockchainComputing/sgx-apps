wwith open("/data/dataset.txt", "r") as fin:
   with open("/scone/result.txt", "w+") as fout:
       data = fin.read()
       fout.write(data)
       print(data)
