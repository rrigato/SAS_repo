ods rtf file= "C:\Users\Punkiehome1\Documents\stat 6509\hw5output.rtf";
data problem6_5;
	input y x1 x2;
	cards;
	   64.0    4.0    2.0
   73.0    4.0    4.0
   61.0    4.0    2.0
   76.0    4.0    4.0
   72.0    6.0    2.0
   80.0    6.0    4.0
   71.0    6.0    2.0
   83.0    6.0    4.0
   83.0    8.0    2.0
   89.0    8.0    4.0
   86.0    8.0    2.0
   93.0    8.0    4.0
   88.0   10.0    2.0
   95.0   10.0    4.0
   94.0   10.0    2.0
  100.0   10.0    4.0
;
run;

proc reg data = problem6_5;
	model y = x1 x2;
run;

proc reg data = problem6_5;
	model y = x1 x2;
	output out = myout r = res;
run;

proc univariate data = myout normal plot;
	var res;
run;


proc reg data = problem6_5;
	model y = x1 x2;
	output out = myout2 r = res p=yhat;
run;

proc gplot data = myout2;
	plot res =  x1 *x2;
run;

proc print data = myout2;
run;

proc model data = problem6_5 ;
	parms beta0 beta1 beta2;
	y = beta0 + beta1*x1 + beta2*x2;
	fit y / breusch=(1 x1 x2);
run;

proc reg data = problem6_5 alpha=.01;
	model y = x1 x2 /lackfit;
run;
ods rtf close;
