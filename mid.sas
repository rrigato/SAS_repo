ods rtf file= "C:\Users\Punkiehome1\Documents\stat 6509\midterm.rtf";
data takehome;
	input score	Grade1: $2. Grade2: $2.;
	if grade1="A" then gp1=4;
	if grade1="A-" then gp1=3.7;
	if grade1="B+" then gp1=3.3;
	if grade1="B" then gp1=3;
	if grade1="B-" then gp1=2.7;
	if grade2="A" then gp2=4;
	if grade2="A-" then gp2=3.7;
	if grade2="B+" then gp2=3.3;
	if grade2="B" then gp2=3;
	if grade2="B-" then gp2=2.7;
cards;
31	A	A-
33	A	A
33	A	A
33	A	A
31	A	A
30	A	A
34	A	A
32	A	A-
35	A	A
33	A	A-
34	A-	A
32	A-	A-
33	A-	A
30	A-	A-
35	A-	A-
31	A-	A-
34	A-	A
27	B+	A-
30	B+	B+
28	B+	B+
30	B+	B 
30	B	B-
35	B	B
29	B	B-
36	A	A-
36	A	A
32	A	A
33	A	A
35	A	A
36	A	A
35	A	A
32	A	A-
35	A	A
35	A	A-
34	A-	A
31	A-	A-
34	A-	A
35	A-	A-
33	A-	A-
34	A-	A-
32	A-	A
28	B+	A-
30	B+	B+
28	B+	B+
30	B+	B 
28	B	B-
28	B	B
30	B	B-
run;


proc reg data = takehome;
	model score = gp1 gp2;
run;

proc reg data = takehome;
	model score = gp1 gp2;
	output out = myout r=res;
run;
proc univariate data = myout normal plot;
	var res;
run;
*constant variance;
proc model data = takehome;
	parms beta0 beta1 beta2;
	score = beta0 + beta1*gp1 + beta2*gp2;
	fit score / breusch=(1 gp1 gp2);
run;
*lack of fit test;
proc reg data = takehome;
	model score = gp1 gp2 /lackfit;
run;
data takehome2;
	set takehome;
	gp12product = gp1*gp2;
	drop Grade1 Grade2;
run;
proc gplot data=takehome2;
	plot score*gp12product ;
run;

proc reg data = takehome2;
	model score = gp12product;
	test gp12product;
run; 
data problem2;
	set takehome;
	loggp1 = log(gp1);
	loggp2= log(gp2);
	gp1sqr = gp1*gp1;
	gp2sqr = gp2*gp2;
	gp1cube = gp1*gp1*gp1;
	gp2cube = gp2*gp2*gp2;
	gp12ratio = gp1/gp2;
	gp12product = gp1*gp2;
	gp21ratio = gp2/gp1;
	drop Grade1 Grade2;
run;

proc corr data = problem2;
run;

proc reg data = problem2;
	model score = gp1 gp2 loggp1 loggp2 gp1sqr gp2sqr 
	gp1cube gp2cube gp12ratio gp12product gp21ratio / selection=adjrsq;
run;

proc reg data = problem2;
	model score = gp1 gp2 loggp1 loggp2 gp1sqr gp2sqr gp1cube 
	gp2cube gp12ratio gp12product gp21ratio / selection=cp;
run;

proc reg data = problem2;
	model score = gp1 gp2 loggp2 gp1sqr gp2sqr gp12ratio gp21ratio;
run;
ods rtf close;
