data f151;
	do i=1 to 2;
		if i=2 then acid='yes';
		if i=1 then acid='no';
		do rep=1 to 3;
			do j=1 to 4;
				if j=4 then shape="rectangular";
				else if j=2 then shape="diagonal";
				else if j=3 then shape="check";
				else if j=1 then shape="circular";
				input resin @@;
				output;
			end;
		end;
	end;
	cards;
	9 43 60 77
	13 48 65 70
	12 57 70 91
	15 66 75 97
	13 58 78 108
	20 73 90 99
run;


proc print data = f151;
run;

proc means data=f151;
	class acid;
	var resin;
run;


proc means data=f151;
	class shape;
	var resin;
run;

proc glm data = f151;
	class acid;
	model resin = acid;
	output out=myout r=res;
run;


*checks for normality of residuals;
proc univariate data=myout normal plot;
	var res;
run;







*part b;
proc glm data = f151;
	class shape;
	model resin = shape;
	output out=myout r=res;
	*checks for equality of variance can also use hovtest=bf;
	means shape /hovtest=levene;
run;


proc glm data=f151 alpha=.01;
	class shape acid;
	model resin=shape;
	*checks for whether the mean resin amounts differ for each shape;
	lsmeans shape / pdiff;
	lsmeans shape / pdiff adjust=tukey;
run;



*part c;
proc glm data=f151 alpha=.01;
	class shape acid;
	model resin=shape|acid;
	output out =myout r=res;
run;



*checks for normality of residuals;
proc univariate data=myout normal plot;
	var res;
run;






/*****************************************
**
*fall 15 problem 2
*
*
*******************************************/



/* 

first 5 rows of data
year,sales_b,price_index,pop_m,realgdp_b,ad_gdppct
1931,6.7,23.231,124.04,904.8,2.7
1932,4.9,19.081,124.84,788.2,2.8
1933,4.5,19.446,125.58,778.3,2.3
1934,5.5,22.545,126.37,862.2,2.5
1935,5.8,22.147,127.25,939,2.3*/

PROC IMPORT OUT= WORK.F152 
            DATAFILE= "C:\Users\Punkiehome1\Downloads\Expenditure (1).cs
v" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

/*****if I needed to insert a value
proc sql;
	insert into f152 values(2008, ., ., 296, 13800.5,2.7);
run;
*/
proc print data=f152;
run;


data f1522;
	set f152;
	real_sales =  100*sales_b/price_index;
run;


proc gplot data = f1522;
	plot realgdp_b*real_sales;
run;
	
proc reg data=f1522;
	model real_sales = year;
	output out = myout r=res;
run;


proc reg data = f1522 ;
	model real_sales = year  pop_m realgdp_b ad_gdppct /selection=stepwise slentry=.1 slstay=.1;
	output out = myout r=res;
run;

proc univariate normal plot data= myout;
	var res;
run;



*checking for lack of fit
doesnt work cause I dont have repeated observations;

proc reg data = f1522 ;
	model real_sales =   pop_m realgdp_b ad_gdppct /lackfit;

run;



*checking for homegeneity;
proc model data = f1522 ;
	parms beta0 beta1 beta2 beta3 beta4 ;
	real_sales = beta0 + beta1*pop_m + beta2*realgdp_b + beta3*ad_gdppct ;
	fit real_sales / white breusch =(1 pop_m realgdp_b ad_gdppct);
run;




*90 % prediction interval;
proc reg data = f1522 alpha=.1;
	model real_sales =   pop_m realgdp_b ad_gdppct ;
	output out = myout r= res ucl=ucl lcl=lcl
	uclm=uclm lclm=lclm p=pred;

run;


*problem 3;

data f153;
input Degree	Newspaper Gender $	Count;
Y=min(1, 5-Newspaper);
cards;
1	1	F	1833
2	1	F	1929
3	1	F	624
4	1	F	1162
5	1	F	685
1	2	F	762
2	2	F	1198
3	2	F	231
4	2	F	521
5	2	F	207
1	3	F	622
2	3	F	350
3	3	F	142
4	3	F	275
5	3	F	85
1	4	F	471
2	4	F	973
3	4	F	104
4	4	F	197
5	4	F	66
1	5	F	516
2	5	F	527
3	5	F	30
4	5	F	66
5	5	F	33
1	1	M	1385
2	1	M	3514
3	1	M	340
4	1	M	1266
5	1	M	805
1	2	M	573
2	2	M	1589
3	2	M	153
4	2	M	424
5	2	M	171
1	3	M	448
2	3	M	786
3	3	M	82
4	3	M	165
5	3	M	63
1	4	M	312
2	4	M	622
3	4	M	67
4	4	M	109
5	4	M	41
1	5	M	426
2	5	M	337
3	5	M	25
4	5	M	54
5	5	M	18
;
run;





 proc logistic data = f153 order=data;
 class Degree Gender/param = ref;
 freq count;
 model Newspaper= Degree gender/link=clogit aggregate scale=none ;
 output out = prob PREDPROBS=I;
run;


proc logistic data = one order=data;
 class Degree Gender/param = ref;
 freq count;
 model Y= Degree gender / link=logit ;
run; 







*************************************problem 4;



quit;
