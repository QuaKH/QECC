# dir="./KhoHo/output/knot_${1} +"_" + str(n) + "/" + str(i) + "_" + str(j), "w""
# mkdir $dir
cd KhoHo
pwd
echo "import get_d; get_d.get_d(${1}, ${2}, ${3}, ${4})" | sage
cd ..
