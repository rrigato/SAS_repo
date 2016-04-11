PROC IMPORT OUT= WORK.PROB2 
            DATAFILE= "C:\Users\Punkiehome1\Downloads\Expenditure.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

proc print data = Prob2;
run;

data Prob2A;
	set Prob2;
	real_sales = (100*sales_b)/price_index;
run;

proc gplot data = Prob2A;
	plot realgdp_b*real_sales;
run;


proc reg data = Prob2A;
	model real_sales = year;
	output out = myout r = res;
run;

proc print data=Prob2A;
run;


proc reg data = Prob2A;
	model real_sales = year  price_index pop_m realgdp_b ad_gdppct /selection =FORWARD;
	output out = myout r = res ;
run;
