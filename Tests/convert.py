file_name = input()
file_name += ".hex"

with open(file_name, 'r') as f:
    lines = f.readlines()

while(len(lines) < 256):
    lines.append("00000013\n") # nops 

with open(file_name, 'w') as f:
    f.writelines(lines)