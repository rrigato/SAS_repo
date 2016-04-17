data prob1;
input 
type $	bag $	color $	count;
cards;
plain	1	1	10
plain	1	2	14
plain	1	3	14
plain	1	4	5
plain	1	5	6
plain	1	6	9
peanut	2	1	3
peanut	2	2	6
peanut	2	3	8
peanut	2	4	1
peanut	2	5	2
peanut	2	6	1
plain	3	1	8
plain	3	2	16
plain	3	3	14
plain	3	4	10
plain	3	5	4
plain	3	6	5
peanut	4	1	1
peanut	4	2	5
peanut	4	3	2
peanut	4	4	4
peanut	4	5	6
peanut	4	6	1
peanut	5	1	1
peanut	5	2	7
peanut	5	3	1
peanut	5	4	6
peanut	5	5	4
peanut	5	6	3
plain	6	1	7
plain	6	2	17
plain	6	3	10
plain	6	4	6
plain	6	5	8
plain	6	6	5
plain	7	1	8
plain	7	2	16
plain	7	3	12
plain	7	4	9
plain	7	5	6
plain	7	6	7
peanut	8	1	3
peanut	8	2	5
peanut	8	3	4
peanut	8	4	6
peanut	8	5	0
peanut	8	6	3
plain	9	1	6
plain	9	2	10
plain	9	3	18
plain	9	4	6
plain	9	5	8
plain	9	6	7
peanut	10	1	4
peanut	10	2	3
peanut	10	3	2
peanut	10	4	3
peanut	10	5	3
peanut	10	6	4
plain	11	1	3
plain	11	2	25
plain	11	3	15
plain	11	4	6
plain	11	5	3
plain	11	6	4
peanut	12	1	1
peanut	12	2	5
peanut	12	3	3
peanut	12	4	4
peanut	12	5	4
peanut	12	6	4
peanut	13	1	1
peanut	13	2	4
peanut	13	3	1
peanut	13	4	4
peanut	13	5	3
peanut	13	6	5
plain	14	1	6
plain	14	2	8
plain	14	3	24
plain	14	4	3
plain	14	5	9
plain	14	6	8
;
run;


*sp15 prob1.B;
proc anova data = prob1;
	class type bag color;
	*bag is nested within type;
	model count = type  color bag(type) type*color ;
	*gives the multiple comparison procedure;
	means color /tukey;
run;



*sp15 prob1.D;
*for the mulitple comparison procedure, means with the same
letter are not statistically different;
proc glm data = prob1 alpha=.05;
	class type bag color;
	*bag is nested within type;
	model count = type  color bag(type) type*color ;
	*gives the multiple comparison procedure;
	means color /tukey;
	*gets the residuals to test for normality;
	output out = myout r = res;
run;





*Tests for normality of residuals;
proc univariate  normal plot data = myout;
	var res;
run;












/***********************************************************************************************************
*
*		Regression model using automatic selction techniques
*
*
*
************************************************************************************************************/








data prob2;
input Rows	salary	Draft	yrs_exp	played	started	citypop;

cards;
1	236000	1	2	16	16	2737000
2	250000	6	5	16	5	2737000
3	185000	10	4	16	16	4620000
4	165000	13	2	6	0	4620000
5	250000	1	3	16	4	13770000
6	300000	11	7	16	13	13770000
7	300000	3	7	11	8	2388000
8	1000000	8	10	14	12	2388000
9	225000	13	5	11	7	1307000
10	475000	7	6	16	15	1307000
11	425000	3	7	16	1	18120000
12	310000	8	6	16	0	18120000
13	287500	4	4	13	10	18120000
14	700000	1	5	16	15	5963000
15	1275000	2	6	16	16	5963000
16	185000	12	5	15	1	2030000
17	700000	1	2	2	1	2030000
18	325000	4	6	16	1	2030000
19	155000	3	2	7	0	6042000
20	500000	3	2	8	6	1995000
21	204000	2	2	13	1	1995000
22	1366700	1	4	14	14	1995000
23	160000	3	2	14	0	1176000
24	1050000	1	10	16	14	1728000
25	98000	7	2	11	0	1728000
26	370000	3	2	10	1	3641000
27	450000	2	6	16	8	1237000
28	195000	2	1	1	0	1575000
29	1500000	1	8	16	16	3001000
30	420000	8	13	14	0	4110000
;
run;


data prob22;
	set prob2;
	log_salary = log(salary);
	draftInverse = 1/Draft;
run;

*problem2.A;
proc gplot data = prob22;
	plot salary*Draft;
run; 

proc gplot data = prob22;
	plot log_salary*Draft;
run; 


*problem2.B;
proc reg data = prob22;
	model log_salary = draftInverse;
	output out = myout r = res;
run;




*problem2.C;
*CLM gives confidence intervals, CLI gives prediction intervals;
proc reg data = prob22;
	model log_salary = draftInverse / clb;
	output out = myout r = res ;
run;


proc print data = prob22;
run;


data prob22D;
	set prob22;
	log_salary = log(salary);
	pctStart = started/played;
	draftInverse = 1/Draft;
run;


*problem 2.D;
*selction methods:
selection  = forward
selction = backword
selection = cp
selection = stepwise
selection=ADJRSQ
options: slstay = .05(alpha) slentry = .05(alpha) these are for adjusting alpha values;

proc reg data = prob22D;
	model log_salary = draftInverse yrs_exp played started citypop pctStart 
			/selection=stepwise slentry=.1 slstay=.1 ;
	output out = myout2 r = res ;
run;




*check for normality of error terms;
proc univariate data = myout2;
	var res;
run;

*tests for heteroskedasticity
null hypothesis is homoskedasticity
alternative is he
assumption that variance of error terms is constant;
proc model data = prob22D ;
	parms beta0 beta1 beta2 beta3;
	log_salary = beta0 + beta1*pctStart + beta2*yrs_exp + beta3*draftInverse;
	fit log_salary / breusch=(1 pctStart yrs_exp draftInverse);
run;

quit;

*check to make sure linearity is appropriate;
proc reg data = prob22D;
	model log_salary = draftInverse yrs_exp pctStart 
			/lackfit;
	output out = myout2 r = res ;
run;


*add an observation with a missing y value to get a new prediction interval
without changing the ols line;


data probMiss;
input Rows	salary	Draft	yrs_exp	played	started	citypop;

cards;
1	236000	1	2	16	16	2737000
2	250000	6	5	16	5	2737000
3	185000	10	4	16	16	4620000
4	165000	13	2	6	0	4620000
5	250000	1	3	16	4	13770000
6	300000	11	7	16	13	13770000
7	300000	3	7	11	8	2388000
8	1000000	8	10	14	12	2388000
9	225000	13	5	11	7	1307000
10	475000	7	6	16	15	1307000
11	425000	3	7	16	1	18120000
12	310000	8	6	16	0	18120000
13	287500	4	4	13	10	18120000
14	700000	1	5	16	15	5963000
15	1275000	2	6	16	16	5963000
16	185000	12	5	15	1	2030000
17	700000	1	2	2	1	2030000
18	325000	4	6	16	1	2030000
19	155000	3	2	7	0	6042000
20	500000	3	2	8	6	1995000
21	204000	2	2	13	1	1995000
22	1366700	1	4	14	14	1995000
23	160000	3	2	14	0	1176000
24	1050000	1	10	16	14	1728000
25	98000	7	2	11	0	1728000
26	370000	3	2	10	1	3641000
27	450000	2	6	16	8	1237000
28	195000	2	1	1	0	1575000
29	1500000	1	8	16	16	3001000
30	420000	8	13	14	0	4110000
31	.		1	5	7	2	.  
;
run;

data probMiss;
	set probMiss;
	log_salary = log(salary);
	pctStart = started/played;
	draftInverse = 1/Draft;
run;
proc reg data = probMiss;
	model log_salary = draftInverse yrs_exp pctStart 
			;
			*get the confidence limits and prediction limits into the output statement;
	output out = myout2 r = res  lclm=lowmean 
		uclm=upmean lcl=lowpred ucl=uppred;
run;

quit;
