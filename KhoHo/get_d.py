from sage.all import *
import numpy as np
import ast
import os

"""
d0 is delta0, d1 is delta1
cohomology is ker d1/im d0
homology is ker delta0.T / im delta1.T
   del1   del0
C_1 -> C_0 -> C_-1
    d1     d0
C^1 <- C^0 <- C^-1
"""
# i, j represent the (i,j) bigrading of a chain group we are interested in
# k knot crossing number, n type in table
def get_d(k, n, i, j):

    file_path_0 = "./differentials/knot_"+ str(k) +"_" + str(n) + "_dense-i-j/" + str(i) + "_" + str(j)
    file_path_1 = "./differentials/knot_"+ str(k) +"_" + str(n) + "_dense-i-j/" + str(i + 1) + "_" + str(j)
    data0 = ""
    data1 = ""

    # check if file is present
    if os.path.isfile(file_path_0):
        text_file = open(file_path_0, "r")
        data0 = text_file.read()
        text_file.close()
    else:
        with open("./output/knot_"+ str(k) +"_" + str(n) + "/" + str(i) + "_" + str(j), "w") as f:
            f.write("trivial i")
            return

    if os.path.isfile(file_path_1):
        text_file = open(file_path_1, "r")
        data1 = text_file.read()
        text_file.close()
    else:
        with open("./output/knot_"+ str(k) +"_" + str(n) + "/" + str(i) + "_" + str(j), "w") as f:
            f.write("trivial i + 1")
            return

    z2 = GF(2)
    #d0, d1 are numpy arrays
    d0 = better_format(data0)
    d1 = better_format(data1)
    d0t = d0.T
    d1t = d1.T

    d1_mat = matrix(z2,d1)
    d0_mat = matrix(z2,d0)

    d1t_mat = matrix(z2, d1t)
    d0t_mat = matrix(z2, d0t)

    d1_list = list(d1_mat.right_kernel())
    d0_list = list(d0_mat.column_space())

    # logical_qubit_num equals the dimension of cohomology Hij
    # physical_qubit_num equals the dimension of the corresponding chain group Cij
    logical_qubit_num = get_dim(d1_mat.right_kernel(), d0_mat.column_space())
    physical_qubit_num = len(d1[0])
    cohomology = get_homology(d1_list, d0_list)

    d1t_list = list(d1t_mat.column_space())
    d0t_list = list(d0t_mat.right_kernel())
    homology = get_homology(d0t_list, d1t_list)

    dis = get_distance(cohomology, homology)

    with open("./output/knot_"+ str(k) +"_" + str(n) + "/" + str(i) + "_" + str(j), "w") as f:
        f.write("distance: " + str(dis))
        f.write("\n")
        f.write("logical qubit number: " + str(logical_qubit_num))
        f.write("\n")
        f.write("physical qubit number: " + str(physical_qubit_num))
        f.write("\n")
        f.write("ratio: " + str(float(logical_qubit_num / physical_qubit_num)))
        f.write("\n")
        f.write(str(z2))


# L1, L2 are matrices in list forms; will perform L1 / L2 (quotient)
def get_homology(L1, L2):
    list1 = L1.copy()
    list2 = L2.copy()
    print(list1)
    print()
    print(list2)
    print()
    if len(list1) == len(list2):
        return []

    while len(list2) > 0:
        for i in range(len(list2)):
            for j in range(len(list1)):
                if list2[i] == list1[j]:
                    list2.pop(i)
                    list1.pop(j)
                    break
            break

    return list1


# ch, h are lists; ch is list of all elements in cohomology H^1, h H_1
# returns dis, the min number of bitwise 1's from selecting an element from ch and h
def get_distance(ch, h):
    dis = -1
    for i in range(len(ch)):
        for j in range(len(h)):
            count = 0
            for a in range(len(ch[0])):
                if ch[i][a] == 1 or h[j][a] == 1:
                    count += 1

            if i == 0 and j == 0:
                dis = count
            elif dis > count > 0:
                dis = count
    if dis == -1:
        dis = 0
    return dis

# transforms matrix string from pari/gp to numpy array
def better_format(a):
    str_a = str(a)
    str1 = ""
    if (a[0] == "M"):
        new_a = a[4:].replace(")", "]")
        str1 = "[" + new_a
    else:
        new_a = str_a.replace("; ", "], [")
        str1 = "[" + new_a + "]"
    res = ast.literal_eval(str1)
    return np.array(res)

# get the dimension of cohomology by dim kerd1 - dim im d0
def get_dim(d1, d0):
    return d1.dimension() - d0.dimension()