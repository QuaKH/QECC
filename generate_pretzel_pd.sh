cd KhoHo
pwd

echo "write_pretzel_pdcode(${1}, ${2}, ${3}, ${4}, ${5}, ${6})" | gp -s 120000000 KhoHo unpack_matrix.gp

echo "done"

cd ..