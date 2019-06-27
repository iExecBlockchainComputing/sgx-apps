def main():
    with open("/iexec_in/data/data.txt","r") as fin:
        with open("/scone/result.txt","w+") as fout:
            data = fin.read()
            fout.write("Data: " + data)
            print("Data: " + data)

if __name__ == "__main__":
     main()
