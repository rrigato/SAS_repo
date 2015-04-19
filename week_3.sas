ods rtf file= "C:\Users\Punkiehome1\Documents\stat 6509\hw3output.rtf";
data problem3_5;
input broken_ampules transfers;
cards;
   16.0    1.0
    9.0    0.0
   17.0    2.0
   12.0    0.0
   22.0    3.0
   13.0    1.0
    8.0    0.0
   15.0    1.0
   19.0    2.0
   11.0    0.0
   ;
   run;

   proc reg data = problem3_5;
   		model broken_ampules = transfers;
		output out= myout r= res;
	run;

	proc univariate data = myout plots;
	var res;
	run;
	proc print data = myout;
	var res transfers;
	run;
	proc gplot data = myout;
	plot res*transfers;
	run;

	proc sort data = myout;
	by transfers;

	proc model data = problem3_5;
	parms beta0 beta1;
	broken_ampules = beta0 + beta1*transfers /*xvar*/;
	fit broken_ampules/breusch =(1 transfers);
run;
	
data first;
    input transfers breaks;
    time=_n_;  /*creates a column indicating the observation number*/
        cards;
        1 16
        0 9
        2 17
        0 12
        3 22
        1 13
       0 8        
        1 15
        2 19
        0 11
   run;
    proc reg;
       model breaks = transfers / clb;
       output out=myout r=res;
    run;
    ods graphics off;
    proc univariate normal plot;  /* proc univariate provides a stem plot when 
                                    in low-res graphics */
        var res;
    run;
    ods graphics on;  /* turn graphics back on for nice graphs */
    proc gplot;
        symbol interpol=join value=dot;  /* join means connect the dots */
        plot res*time;
    run;
    quit;
 data problem3_18;
 input num_hours lot_size;
 cards;
 14.28        15
    8.80         9
   12.49         7
    9.38         4
   10.89         9
   15.39        21
   13.09        11
   12.35         6
   10.66        10
    8.12         7
   12.61        12
    8.61         2
   10.99         6
    8.65         5
   11.52        10
    7.25         3
    2.63         3
    9.61         4
   20.20        20
   19.68        17
   13.46        13
   18.45        30
   18.05        21
    9.76         4
   18.27        15
   14.38        17
   13.27        13
   11.40        10
   12.32         7
   19.06        23
   10.66         7
   13.88        16
    2.53         3
   11.21         3
   13.28        10
   16.79        21
   13.04         5
   10.60         7
   19.41        26
    8.56         7
   20.87        22
    9.80         8
   15.33        14
   13.78        11
   11.77         9
   16.65        18
   12.11        10
   14.31         6
   10.38         4
   12.66        13
   15.71        13
   17.66        17
   12.94        13
   12.14         8
    7.11         2
   21.97        33
    9.02         3
    8.90         4
   15.75        25
   11.80        12
   12.52        14
   12.45         6
   18.35        24
   10.81         8
   11.86        12
    9.00         4
    8.54         4
   17.11        14
   17.50        16
   10.74         6
   16.57        16
   16.46        15
   17.24        22
   15.03        12
   14.65        10
    8.66         8
   20.70        21
    8.27         9
   11.99         8
   11.01         6
   13.72         7
   11.15         7
   18.80        18
   21.94        23
   22.35        27
    9.49         8
   11.43         8
   12.84        14
   10.64         5
   14.95        14
   13.29        10
   19.25        16
    7.78         8
   11.37         6
   15.86        18
    6.69         6
   13.34        17
   12.13        10
   14.62         8
    7.63         6
    0.51         0
   10.41         8
   11.91         6
   18.88        21
   11.15         9
    9.23         6
   10.65        10
   13.53        11
   16.37        12
   11.45         9
   15.78        15
   ;
   run;

   proc gplot data = problem3_18;
   symbol interpol=seperate;
   	plot num_hours * lot_size ;
   run;

   data problem3_18sqrt;
   set problem3_18;
   lot_sq = sqrt(lot_size);
   run;
   proc reg data = problem3_18sqrt;
   		model num_hours = lot_sq;
		output out = prob3 r = res p=fitted;
	run;

	proc gplot data = prob3;
		plot res*fitted;
	run;
	proc univariate normal plot data = prob3;
		var res;
	run;
	proc reg data = problem3_18;
		model num_hours = lot_size;
	run;
quit;

ods rtf close;
