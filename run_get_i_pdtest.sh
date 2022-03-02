if [ -d "./KhoHo/differentials/pdcode_example" ]

then
    rm -R "./KhoHo/differentials/pdcode_example"
    rm -R "./KhoHo/output/pdcode_example"
fi

dir1="./KhoHo/differentials/pdcode_example"
mkdir $dir1
dir2="./KhoHo/output/pdcode_example"
mkdir $dir2

cd KhoHo
pwd
echo "compute_knot_differential_pdtest()" | gp -s 120000000 KhoHo unpack_matrix.gp
cd ..

cd KhoHo
pwd
echo "import get_d; get_d.get_d_pdtest()" | sage
cd ..