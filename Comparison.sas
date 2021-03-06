data f141;
	input  Subject $ TypeMusic $ 	TypingEfficiency;
	cards;
1	'NoMusic'	20
2	'NoMusic'	17
3	'NoMusic'	24
4	'NoMusic'	20
5	'NoMusic'	22
6	'NoMusic'	25
7	'NoMusic'	18
1	'HardRock'	20
2	'HardRock'	18
3	'HardRock'	23
4	'HardRock'	18
5	'HardRock'	21
6	'HardRock'	22
7	'HardRock'	19
1	'Classical'	24
2	'Classical'	20
3	'Classical'	27
4	'Classical'	22
5	'Classical'	24
6	'Classical'	28
7	'Classical'	16
;
run;

proc anova data = f141  ;
	class Subject TypeMusic;
	model TypingEfficiency = Subject TypeMusic;
	/*Tukey Pairwise comparison procedure
	Controlling for familywise error rate at .1*/
	      means TypeMusic / tukey alpha= .1;
run;
	


data f142;
	input  Person	Gender $ 	Age	Intelligence	Extroversion SWeek;

cards;
1	F	27	89	21	2625
2	F	25	93	24	2700
3	M	29	101	21	3100
4	F	40	122	23	3550
5	M	41	115	27	3175
6	F	35	100	18	2800
7	M	30	98	19	2700
8	M	54	100	16	2475
9	F	42	119	28	3625
10	F	37	109	28	3525
11	M	38	130	20	3225
12	F	36	114	25	3450
13	F	50	91	20	2425
14	F	32	111	26	3025
15	M	33	123	28	3625
16	M	29	115	29	2750
17	M	35	113	25	3150
18	F	25	88	23	2600
19	F	24	102	19	2525
20	M	51	101	16	2650
21	M	33	121	25	3190
22	F	40	112	20	2980
23	F	23	110	20	2735
24	F	37	112	25	3600
25	M	30	121	29	3700
26	F	30	120	19	.
;
run;


*A and B;
proc glm data = f142 ;
	class Gender;
	model SWeek = Extroversion Intelligence Age Gender / solution clm alpha = .02;
	output out = myout r = res lclm=lowCI uclm=upCI alpha=.02;
run;


data resm;
	merge f142 myout;
	by Person;
run;

proc gplot data = resm;
	plot Res*Age;
run;


*c, D, and E;
data f1422; set f142;
	age_square=age*age; run;

proc glm data=f1422;
	class Gender;
	model SWeek=Gender age age_square Intelligence
	 Extroversion/solution;
run;

proc reg data=f1422;
	model SWeek= age age_square Intelligence Extroversion;
	 plot r.*p.; *test for Heteroscedasticity;
	output out=myout lcl=lcl lclm=lclm ucl=ucl
	uclm=uclm r=res;
run;



proc univariate data = myout normal plot;
	var res;
run;



*White and Breusch pagan test for heteroskedasticity;

proc model data = f1422 ;
	parms beta0 beta1 beta2 beta3 beta4;
	SWeek = beta0 + beta1*age + beta2*age_square + beta3*intelligence  + beta4*Extroversion;
	fit SWeek / white breusch =(1 age age_square Intelligence Extroversion);
run;

quit;




quit;


data f143;
input Soc $	Scout	Del	Count;
cards;
low-med	1	1	20
low-med	0	1	52
low-med	1	0	94
low-med	0	0	229
med-hi	1	1	15
med-hi	0	1	12
med-hi	1	0	252
med-hi	0	0	126
run;





proc sort data = f143;
	by soc;
run;

*test for independence;
proc freq data = f143;
	weight count;
	by soc;
	table scout * del/ chisq;
run;

*look at the chi-square statistic in the table;
proc freq data = f143;
	weight count;
	table scout*del/chisq;
run;




proc genmod data = f143 order = data;
class soc scout del / descending ;
model count = soc scout del soc*scout soc*del scout*del/ dist = poi link =
log;
run;



data f145;
input x	y;
cards;
3.43	3.3
3.45	3.62
2.85	3.2
3.15	3.12
3.28	3.67
2.8	3.15
3.46	3.63
2.24	2.39
3.75	3.97
3.34	3.16
4	3.69
2.79	3
2.81	2.69
2.73	2.7
3.39	3.75
4	4
3.24	3.68
3.27	3.1
2.89	3
4	4
3.51	3.37
2.89	3.08
3.56	3.29
3.87	4
3.43	3.91
;
run;

data prob5ax;
	set f145;
	gpa=x;
	group='x';
run;
data prob5ay;
set f145;
gpa=y;
group= 'y';
run;
data prob5a;
set prob5ay prob5ax;
run;


proc ttest data = prob5a sides=L; /* part i*/
class group;
var gpa;
run;
proc ttest data = prob5a; /* part ii*/
class group;
var gpa;
run;


*H0: u = 3.1 Ha: u >3.1;
proc ttest h0=3.1 data=prob5a sides=U;
var gpa;
run;


proc ttest data=prob5a;
var gpa;
run;


*paired t test;
proc ttest data=prob5a;
paired x*y;
run;
