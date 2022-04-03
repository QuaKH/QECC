/* Given the index (datapos) of a diagram whose differentials have already been computed, and an i,j,   
 * returns the i,j-th differential matrix. i and j are the indices of the matrices in the big matrix of
 * differentials. NOT the i and j of the grading
 */
get_differential_m(datapos, i, j) =

{
	local(entry, mat);

	mat=matrix(chain_ranks[datapos][j, i + 1], chain_ranks[datapos][j, i]);

	for (pos = 1, allmatr_length[datapos][i, j],

		if (is_arch_64,

			entry = allmatr[datapos][i, j][pos];

			mat[abs(entry) \ arch64_mask, abs(entry) % arch64_mask] = sign(entry);

		,

			mat[allmatr[datapos][i, j][2*pos - 1], 

				    abs(allmatr[datapos][i, j][2 * pos])] = 

					sign(allmatr[datapos][i, j][2 * pos]);

		);

	);
	return(mat);

}

/* Given the index (datapos) of a diagram whose differentials have already been computed, and an i,j,   
 * returns the i,j-th differential matrix.
 */
get_differential(datapos, i, j) = 
{
	return(get_differential_m(datapos, i2m(datapos, i), j2m(datapos, j)))
}

/**
 * fetch differential for loaded knot (at datapos), write to file
 */
write_differential_to_file(crossings, index, datapos, x, y) = {

	local(entry, row, col, val, i, j);
		
	/*
		TODO: fix convention; add negatives
	*/

	i = i2m(datapos, x);
	j = j2m(datapos, y);

	

	if (length(allmatr[datapos][i,j]) > 0,

		/* write matrix dimension to file */
		write(
			Str("./differentials/knot_",crossings,"_",index,"/",knot,"_",crossings,"_",index,"__d_",x,"_",y),
			Str(chain_ranks[datapos][j, i + 1], " ", chain_ranks[datapos][j, i])
		);

		/* write differential matrix to file in sparse format */
		write (
			Str("./differentials/knot_",crossings,"_",index,"/",knot,"_",crossings,"_",index,"__d_",x,"_",y),
			allmatr[datapos][i,j]
		),
		
		return 0;
	);

	return 1;
}

/**
 * compute all differentials of specified knot and write to file
 */
compute_knot_differential(crossings, index) = {
	
	local(x,y);

	KTable(crossings, index, 1);
	assignDmatrices(1);

	for (x = DStore[1].iLow,
		DStore[1].iHigh - 1,
		for (y = DStore[1].jLow,
			DStore[1].jHigh,

			write_differential_to_file(crossings, index, 1, x, y);

		);
	);

	return 1;
}

compute_pd_code_differential(pd_code, crossings, index) = {

	local(datapos, x, y);
	/* add matrix of 1s to pd_code to convert to 1-indexing */
	datapos = init_diagr(pd_code + matrix(crossings,4,i,j,1), "a");

	assignDmatrices(datapos);

	for (x = DStore[datapos].iLow,
		DStore[datapos].iHigh - 1,
		for (y = DStore[datapos].jLow,
			DStore[datapos].jHigh,

			write_differential_to_file(crossings, index, datapos, x, y);

		);
	);

	return 1;
}










/**
 * compute all differentials of specified knot and write to file
 */
compute_knot_differential_dense(crossings, index) = {
	
	local(x,y);

	KTable(crossings, index, 1);
	assignDmatrices(1);

	write (
			Str("./differentials/knot_",crossings,"_",index,"_dense-i-j/bound"),

			Str(DStore[1].iLow, " ", DStore[1].iHigh - 1, " ", DStore[1].jLow, " ", DStore[1].jHigh)

		);

	for (x = DStore[1].iLow,
		DStore[1].iHigh - 1,
		for (y = DStore[1].jLow,
			DStore[1].jHigh,

			write_differential_dense_to_file(crossings, index, 1, x, y);

		);
	);

	return 1;
}


/**
 * fetch differential for loaded knot (at datapos), write to file
 */
write_differential_dense_to_file(crossings, index, datapos, x, y) = {

	local(entry, row, col, val, i, j);
		
	/*
		TODO: fix convention; add negatives
	*/

	i = i2m(datapos, x);
	j = j2m(datapos, y);

	

	if (length(allmatr[datapos][i,j]) > 0,

		/* write matrix dimension to file */
		/*
		write(
			Str("./differentials/knot_",crossings,"_",index,"_dense/",knot,"_",crossings,"_",index,"__d_",x,"_",y,"_dense"),
			Str(chain_ranks[datapos][j, i + 1], " ", chain_ranks[datapos][j, i])
		);
		*/

		/* write differential matrix to file in sparse format */
		write (
			Str("./differentials/knot_",crossings,"_",index,"_dense-i-j/",x,"_",y),
			/*
				allmatr[datapos][i,j]
			*/
			get_differential(datapos, x, y)

		),
		
		return 0;
	);

	return 1;
}





/**
 * compute all differentials of specified knot (given the pdcode) and write to file
 */
compute_knot_differential_pdtest() = {
	
	local(x,y);

	pdcode = read(pdcode_test);

	init_diagr(pdcode,test,1);
	
	assignDmatrices(1);

	write (
			Str("./differentials/pdcode_example/bound"),

			Str(DStore[1].iLow, " ", DStore[1].iHigh - 1, " ", DStore[1].jLow, " ", DStore[1].jHigh)

		);

	for (x = DStore[1].iLow,
		DStore[1].iHigh - 1,
		for (y = DStore[1].jLow,
			DStore[1].jHigh,

			write_differential_pdtest_to_file(1, x, y);

		);
	);

	return 1;
}



/**
 * compute all differentials of specified knot (given the pdcode) and write to file
 */
compute_knot_differential_pd(strfile) = {
	
	local(x,y);

	pdcode = read(strfile);

	init_diagr(pdcode,test,1);
	
	assignDmatrices(1);

	write (
			Str("./differentials_pd/pdcode_1/bound"),

			Str(DStore[1].iLow, " ", DStore[1].iHigh - 1, " ", DStore[1].jLow, " ", DStore[1].jHigh)

		);

	for (x = DStore[1].iLow,
		DStore[1].iHigh - 1,
		for (y = DStore[1].jLow,
			DStore[1].jHigh,

			write_differential_pd_to_file(1, x, y);

		);
	);

	return 1;
}



/**
 * compute all differentials of specified knot (given the pdcode) and write to file
 */
compute_knot_differential_pd_all(strfile, i) = {
	
	local(x,y);

	pdcode = read(strfile);

	init_diagr(pdcode,test,1);
	
	assignDmatrices(1);

	write (
			Str("./differentials_pd/pdcode_",i,"/bound"),

			Str(DStore[1].iLow, " ", DStore[1].iHigh - 1, " ", DStore[1].jLow, " ", DStore[1].jHigh)

		);

	for (x = DStore[1].iLow,
		DStore[1].iHigh - 1,
		for (y = DStore[1].jLow,
			DStore[1].jHigh,

			write_differential_pd_all_to_file(1, x, y, i);

		);
	);

	return 1;
}


loop_pdcode(strfile) = {
	
	local(x);

	line = readstr(strfile);
	pdcode_num = length(line);
	for (x = 1, 
		pdcode_num,
	
		pdcode = eval(line[x]);
		compute_knot_differential_pd_all_(pdcode, x);
	);

	
}


/**
 * compute all differentials of specified knot (given the pdcode) and write to file, without the temp_file
 */
compute_knot_differential_pd_all_(pdcode, i) = {
	
	local(x,y);

	init_diagr(pdcode,test,1);
	
	assignDmatrices(1);

	write (
			Str("./differentials_pd/pdcode_",i,"/bound"),

			Str(DStore[1].iLow, " ", DStore[1].iHigh - 1, " ", DStore[1].jLow, " ", DStore[1].jHigh)

		);

	for (x = DStore[1].iLow,
		DStore[1].iHigh - 1,
		for (y = DStore[1].jLow,
			DStore[1].jHigh,

			write_differential_pd_all_to_file(1, x, y, i);

		);
	);

	return 1;
}


/**
 * fetch differential for loaded knot generated from pdcode (at datapos), write to file
 */
write_differential_pdtest_to_file(datapos, x, y) = {

	local(entry, row, col, val, i, j);
		
	i = i2m(datapos, x);
	j = j2m(datapos, y);

	if (length(allmatr[datapos][i,j]) > 0,

		/* write differential matrix to file in sparse format */
		write (
			Str("./differentials/pdcode_example/",x,"_",y),
			get_differential(datapos, x, y)

		),
		
		return 0;
	);

	return 1;
}


/**
 * fetch differential for loaded knot generated from pdcode (at datapos), write to file
 */
write_differential_pd_to_file(datapos, x, y) = {

	local(entry, row, col, val, i, j);
		
	i = i2m(datapos, x);
	j = j2m(datapos, y);

	if (length(allmatr[datapos][i,j]) > 0,

		/* write differential matrix to file in sparse format */
		write (
			Str("./differentials_pd/pdcode_1/",x,"_",y),
			get_differential(datapos, x, y)

		),
		
		return 0;
	);

	return 1;
}



/**
 * fetch differential for loaded knot generated from pdcode (at datapos), write to file
 */
write_differential_pd_all_to_file(datapos, x, y, linei) = {

	local(entry, row, col, val, i, j);
		
	i = i2m(datapos, x);
	j = j2m(datapos, y);

	if (length(allmatr[datapos][i,j]) > 0,

		/* write differential matrix to file in sparse format */
		write (
			Str("./differentials_pd/pdcode_",linei,"/",x,"_",y),
			get_differential(datapos, x, y)

		),
		
		return 0;
	);

	return 1;
}




/**
 * Generates a number of pretzel knot (link) differentials from their pdcodes and store them into their folders
 */
generate_pretzel(xlow, xhigh, ylow, yhigh, zlow, zhigh) = {

	local(x, y, z);

	for (x = xlow, 
		xhigh,
		for (y = ylow,
			yhigh,
			for (z = zlow,
				zhigh,

				if ((x != 0) && (y != 0) && (z != 0),

					pdcode = pretzel_diagr([x,y,z]);
					compute_pretzel_differential_pd_all(pdcode, x, y, z);
				);
			);
		);
	);
}



/**
 * compute all differentials of specified knot (given the pdcode) and write to file, without the temp_file
 */
compute_pretzel_differential_pd_all(pdcode, i, j, k) = {
	
	local(x,y);

	init_diagr(pdcode,test,1);
	
	assignDmatrices(1);

	write (
			Str("./differentials_pr/pdcode_",i,"_",j,"_",k,"/bound"),

			Str(DStore[1].iLow, " ", DStore[1].iHigh - 1, " ", DStore[1].jLow, " ", DStore[1].jHigh)

		);

	for (x = DStore[1].iLow,
		DStore[1].iHigh - 1,
		for (y = DStore[1].jLow,
			DStore[1].jHigh,

			write_pretzel_pd_all_to_file(1, x, y, i, j, k);

		);
	);

	return 1;
}


/**
 * compute all differentials of specified knot (given the pdcode) and write to file, without the temp_file
 */
compute_pretzel_differential_pd_all2(i, j, k) = {
	
	local(x,y);

	pdcode = pretzel_diagr([i,j,k]);

	init_diagr(pdcode,test,1);
	
	assignDmatrices(1);

	write (
			Str("./differentials_pr/pdcode_",i,"_",j,"_",k,"/bound"),

			Str(DStore[1].iLow, " ", DStore[1].iHigh - 1, " ", DStore[1].jLow, " ", DStore[1].jHigh)

		);

	for (x = DStore[1].iLow,
		DStore[1].iHigh - 1,
		for (y = DStore[1].jLow,
			DStore[1].jHigh,

			write_pretzel_pd_all_to_file(1, x, y, i, j, k);

		);
	);

	return 1;
}



/**
 * fetch differential for loaded knot generated from pdcode (at datapos), write to file
 */
write_pretzel_pd_all_to_file(datapos, x, y, linei, linej, linek) = {

	local(entry, row, col, val, i, j);
		
	i = i2m(datapos, x);
	j = j2m(datapos, y);

	if (length(allmatr[datapos][i,j]) > 0,

		/* write differential matrix to file in sparse format */
		write (
			Str("./differentials_pr/pdcode_",linei,"_",linej,"_",linek,"/",x,"_",y),
			get_differential(datapos, x, y)

		),
		
		return 0;
	);

	return 1;
}