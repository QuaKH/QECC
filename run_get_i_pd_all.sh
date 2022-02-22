if [ -d "./KhoHo/differentials_pd" ]

then
    rm -R "./KhoHo/differentials_pd"
    rm -R "./KhoHo/output_pd"
fi

for i in {1..${2}}
do
    # echo "Welcome $i times"
    dir1="./KhoHo/differentials_pd/pdcode_$i"
    mkdir $dir1
    dir2="./KhoHo/output_pd/pdcode_$i"
    mkdir $dir2

    cd KhoHo
    pwd
    echo "compute_knot_differential_pd_all(${1})" | gp -s 120000000 KH unpack_matrix.gp
    cd ..

    cd KhoHo
    pwd
    echo "import get_d; get_d.get_d_pd($i)" | sage
    cd ..

done