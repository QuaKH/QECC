#! /usr/bin/bash

#SBATCH --partition m
#SBATCH --tasks=1
#SBATCH --mem-per-cpu=4G
#SBATCH --nice=10000
#SBATCH --time=7-00:00
#SBATCH --output=/data/keeling/a/yuxuan19/test_out_%j
#SBATCH --error=/data/keeling/a/yuxuan19/test_error_%j

if [ -d "./KhoHo/differentials_pr" ]

then
    rm -R "./KhoHo/differentials_pr"
    rm -R "./KhoHo/output_pr"
    dir00="./KhoHo/differentials_pr"
    mkdir $dir00
    dir01="./KhoHo/output_pr"
    mkdir $dir01
fi

for i in `eval echo {${1}..${2}}`
do

    for j in `eval echo {${3}..${4}}`
    do

        for k in `eval echo {${5}..${6}}`
        do
            dir1="./KhoHo/differentials_pr/pdcode_${i}_${j}_${k}"
            mkdir $dir1
            dir2="./KhoHo/output_pr/pdcode_${i}_${j}_${k}"
            mkdir $dir2

        done

    done

done

# removing the pretzel(0,0,0) folders
rm -R "./KhoHo/differentials_pr/pdcode_0_0_0"
rm -R "./KhoHo/output_pr/pdcode_0_0_0"

cd KhoHo
pwd

echo "generate_pretzel(${1}, ${2}, ${3}, ${4}, ${5}, ${6})" | gp -s 120000000 KhoHo unpack_matrix.gp

echo "done"

echo "import get_d; get_d.loop_pretzel(${1}, ${2}, ${3}, ${4}, ${5}, ${6})" | sage

cd ..