import sys

LIST = sys.argv[1]
IN = sys.argv[2]

mydict = {"Wz|ZNt2&|pw$":"Wz|ZNt2&|pw$"}

f = open(LIST)
line = f.readline()
while line:
    fname = line[:line.find("\t")]
    difinition = line[line.find("\t"):]
    difinition = difinition.lstrip("\t")
    difinition = difinition.strip("\n")
    mydict[fname] = difinition
    line = f.readline()
f.close()

TXT = open(IN, "r")
mystr = TXT.read()

for k, v in mydict.items():
    mystr = mystr.replace(k, v)

print(mystr)
