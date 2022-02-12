# dir="./KhoHo/differentials/knot_${1}_${2}"
# mkdir $dir
# cd KhoHo
# pwd
# echo "compute_knot_differential(${1}, ${2})" | gp -s 120000000 KH unpack_matrix.gp
# cd ..
#  python3 -c "import get_eigs; get_eigs.get_knot_eigs(\"${dir}\", ${1}, ${2})"
#  unpack_matrix.gp


dir1="./KhoHo/differentials/knot_${1}_${2}_dense-i-j"
mkdir $dir1
dir2="./KhoHo/output/knot_${1}_${2}"
mkdir $dir2
cd KhoHo
pwd
echo "compute_knot_differential_dense(${1}, ${2})" | gp -s 120000000 KH unpack_matrix.gp
cd ..

# dir="./KhoHo/sage_test/test"
# mkdir $dir
# cd KhoHo
# pwd
# echo "import get_d; get_d.get_d(${3}, ${4})" | sage
# cd ..
