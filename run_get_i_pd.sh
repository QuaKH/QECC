if [ -d "./KhoHo/differentials_pd/pdcode_1" ]

then
    rm -R "./KhoHo/differentials_pd/pdcode_1"
    rm -R "./KhoHo/output_pd/pdcode_1"
fi

dir1="./KhoHo/differentials_pd/pdcode_1"
mkdir $dir1
dir2="./KhoHo/output_pd/pdcode_1"
mkdir $dir2

cd KhoHo
pwd
echo "compute_knot_differential_pd(${1})" | gp -s 120000000 KH unpack_matrix.gp
cd ..

cd KhoHo
pwd
echo "import get_d; get_d.get_d_pd('string')" | sage
cd ..