*ctrl + h to replace all commas;
data sp141;
	input subj seq $ AUCFed AUCFasted;
cards;
1 +/- 809.44 967.82
2 +/- 428 746.45
3 -/+ 757.71 901.11
4 -/+ 906.83 1146.96
5 +/- 712.24 678.16
6 -/+ 561.77 745.51
7 +/- 511.84 568.98
8 -/+ 756.6 852.86
;

proc print data = sp141;
run;


/*delete observations in sas

data two
	set sp141;
	delete where seq = '+/-';
run;
*/
proc gplot data = sp141;
	plot; 
run;


*added an observation for the confidence interval;
data sp142;
	input sex    age education race $ reaction_time;
	cards;
1	22	10	white	33.4
0	25	16	white	39.2
0	23	16	Asian	38.8
0	24	17	African	34.8
0	22	15	Other	35.1
0	23	16	African	31.6
1	29	22	Asian	40.1
1	27	16	white	38.2
1	22	11	white	31.1
1	25	18	Asian	36.5
1	23	16	Asian	28.7
0	24	17	African	36.3
0	22	15	Other	36.3
0	23	16	African	38.1
0	29	20	Other	43.5
0	27	16	white	33.6
1	23	16	African	42.4
1	30	16	white	39.4
1	33	10	Asian	38.2
1	35	16	Asian	45.7
1	34	18	African	52.4
0	37	21	Other	52.3
0	37	21	African	51.7
0	39	16	white	51.8
0	39	16	Asian	47.6
0	30	12	Asian	36.6
1	33	12	African	36.6
1	35	12	Other	51.4
1	34	16	white	47.4
1	37	18	Asian	46.4
1	37	21	Asian	50.8
0	39	18	African	49.9
0	39	18	Other	47.5
0	31	12	African	38.0
0	31	12	Other	35.9
0	33	16	Other	40.3
1	40	16	Asian	51.3
1	41	16	white	49.0
1	44	18	white	55.5
1	45	16	Asian	65.2
1	45	18	Asian	60.4
0	46	21	African	64.7
0	48	21	Other	61.2
0	49	16	African	66.0
0	49	16	Other	59.0
0	44	12	white	51.7
1	43	12	white	56.8
1	40	12	Asian	45.7
1	41	16	African	57.2
1	44	18	Other	58.7
1	45	21	Other	61.8
0	45	18	Asian	62.2
0	46	18	white	56.1
0	48	12	white	56.7
0	49	12	Asian	55.1
0	49	16	Asian	67.2
1	44	16	African	54.6
1	43	16	Other	51.2
1	43	18	African	46.2
1	50	16	Other	53.5
1	51	18	white	62.1
0	54	21	white	68.6
0	55	21	Asian	74.0
0	57	16	African	68.8
0	56	16	Other	68.0
0	58	12	Other	64.7
1	59	12	Asian	71.8
1	55	12	white	61.6
1	50	16	white	57.6
1	56	18	Asian	71.1
1	55	21	Asian	75.7
0	56	18	white	66.7
0	57	18	white	69.8
0	60	12	Asian	68.1
0	61	12	African	69.5
0	62	13	Other	71.4
1	66	10	Other	68.3
1	61	12	Asian	62.9
1	63	12	white	70.1
1	64	16	white	79.8
1	61	16	Asian	78.4
0	18	11	Asian	24.8
0	17	10	African	20.7
0	16	9	Other	28.7
1	17	10	African	26.5
1	16	9	Other	27.2
0	18	11	Asian	29.7
0	23	16	African	33.4
1	50	16	white	.
;
run;

*creating dummy variables;
data sp1421;
	set sp142;
	if race ='African' then African=1;
	else African=0;
	if race ='Asian' then Asian=1; 
	else Asian=0;
	if race='white' then Whites=1;
	else whites=0;
run;

*make sure to always use type ss3;
proc reg data = sp1421;
	
	model reaction_time = sex  age  education  African Asian whites;
	output out = myout r = res;
run;


*2b;

*question says stepwise backwards;
proc reg data = sp1421;
	
	model reaction_time = sex  age  education  African Asian whites / selection = StepWise;
	output out = myout r = res;
run;



*checking for homegeneity;
proc model data = sp1421 ;
	parms beta0 beta1 beta2 ;
	reaction_time = beta0 + beta1*age + beta2*education;
	fit reaction_time / white breusch =(1 age education);
run;

*normality;
proc univariate normal plot data = myout;
	var res;
run;



*2d;
*94 %confidence Interval;
proc reg data = sp1421 alpha = .06 ;
	model reaction_time =  age  education  ;
	output out = myout r = res lclm=lclm uclm=uclm
	ucl=ucl lcl=lcl;
run;








data sp143;
	input WAIS	Age	Y;
	cards;
9	94	1
13	77	1
6	83	1
8	94	1
10	82	1
4	75	1
14	77	1
8	91	1
11	95	1
7	76	1
9	83	1
7	79	1
5	82	1
14	88	0
13	76	0
16	77	0
10	95	0
12	76	0
11	83	0
14	92	0
15	80	0
19	93	0
7	81	0
16	83	0
9	76	0
11	75	0
13	95	0
15	84	0
13	92	0
10	83	0
11	73	0
7	78	0
17	76	0
20	86	0
13	82	0
9	78	0
15	80	0
10	92	0
11	81	0
4	75	0
;
run;

*odds ratio, log(p/1-p) = B0 + B1*Wais
log(p/(1-p)) = -2.87 + 1.416*WAIS;
proc logistic data = sp143;
	model Y = WAIS;
	output out = myout ;
run;

*3B;
*values greater than a WAIS of 10;
quit;





proc logistic data = sp143;
	model Y = WAIS age;
	output out = myout ;
run;



quit;
