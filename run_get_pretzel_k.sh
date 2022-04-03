#! /usr/bin/bash

#SBATCH --partition m
#SBATCH --tasks=1
#SBATCH --mem-per-cpu=4G
#SBATCH --nice=10000
#SBATCH --time=7-00:00
#SBATCH --output=/data/keeling/a/yuxuan19/slurm_out/test_out_%j
#SBATCH --error=/data/keeling/a/yuxuan19/slurm_error/test_error_%j

for i in `eval echo {${1}..${2}}`
do

    for j in `eval echo {${3}..${4}}`
    do

        for k in `eval echo {${5}..${6}}`
        do

            if [[ ${i} -ne 0 ]] && [[ ${j} -ne 0 ]] && [[ ${k} -ne 0 ]] && [[ ! -d "./KhoHo/differentials_pr/pdcode_${i}_${j}_${k}" ]]
            then
                dir1="./KhoHo/differentials_pr/pdcode_${i}_${j}_${k}"
                mkdir $dir1
                dir2="./KhoHo/output_pr/pdcode_${i}_${j}_${k}"
                mkdir $dir2

                # doing the calculation each step
                cd KhoHo
                echo "compute_pretzel_differential_pd_all2(${i}, ${j}, ${k})" | gp -s 120000000 KhoHo unpack_matrix.gp
                echo "import get_d; get_d.get_d_pretzel(${i}, ${j}, ${k})" | sage
                cd ..
            fi

        done

    done

done
