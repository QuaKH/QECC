if [ -d "./KhoHo/differentials_pd" ]

then
    rm -R "./KhoHo/differentials_pd"
    rm -R "./KhoHo/output_pd"
    dir00="./KhoHo/differentials_pd"
    mkdir $dir00
    dir01="./KhoHo/output_pd"
    mkdir $dir01
fi

for i in `eval echo {1..${2}}`
do
    dir1="./KhoHo/differentials_pd/pdcode_$i"
    mkdir $dir1
    dir2="./KhoHo/output_pd/pdcode_$i"
    mkdir $dir2
done

cd KhoHo
pwd
    # #python get_pdcode.py var1 var2
    # #python -c "import get_pdcode; get_pdcode.get_pdcode_line(${1}, $i)"
    # echo "import get_pdcode; get_pdcode.get_pdcode_line('${1}', $i)" | sage
    # #echo "import get_pdcode; get_pdcode.get_pdcode_line(${1}, $i)" | python

echo "loop_pdcode(${1})" | gp -s 120000000 KhoHo unpack_matrix.gp

echo "done"

for i in `eval echo {1..${2}}`
do
    echo "import get_d; get_d.get_d_pd_all($i)" | sage
done

cd ..