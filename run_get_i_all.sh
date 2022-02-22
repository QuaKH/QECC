if [ ! -d "./KhoHo/differentials/knot_${1}_${2}_dense-i-j" ]
then
    dir1="./KhoHo/differentials/knot_${1}_${2}_dense-i-j"
    mkdir $dir1
    dir2="./KhoHo/output/knot_${1}_${2}_new"
    mkdir $dir2

    cd KhoHo
    pwd
    echo "compute_knot_differential_dense(${1}, ${2})" | gp -s 120000000 KH unpack_matrix.gp
    cd ..
fi

cd KhoHo
pwd
echo "import get_d; get_d.get_d_all(${1}, ${2})" | sage
cd ..