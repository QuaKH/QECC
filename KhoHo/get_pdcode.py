# returns the i-th line of a file

def get_pdcode_line(filename, i):
    f1=open(filename)
    lines=f1.readlines()
    length_lines = len(lines)

    with open("./temp_pdcode", "w") as f:
        if 0 <= i-1 <= length_lines:
            f.write(lines[i-1])
        else:
            f.write("index out of bounds")
    return

                
