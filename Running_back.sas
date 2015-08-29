PROC IMPORT OUT= WORK.RB_result 

           DATAFILE= "C:\Users\Punkiehome1\Downloads\2014 BFL RB Results.csv"  
	            DBMS=csv	REPLACE;
			  DATAROW=4; 	
     GETNAMES=YES;
RUN;


PROC IMPORT OUT= WORK.RB_predict 
            DATAFILE= "C:\Users\Punkiehome1\Downloads\predict3.csv" 
            DBMS=CSV REPLACE;
			 DATAROW=2; 
     GETNAMES=YES;
RUN;

PROC IMPORT OUT= WORK.RB_ADP 
            DATAFILE= "C:\Users\Punkiehome1\Downloads\RB_ADP2014.csv" 
            DBMS=CSV REPLACE;
			 DATAROW=2; 
     GETNAMES=YES;
RUN;


data RB_1;
	set RB_result;
	result = _N_;
	length name $8;
	name = Running;
	put Running;
run;


data RB_2;
	set RB_predict;
	drop var12;
	drop var16--var28;
	predict = _N_;
	length name $8;   *declares a character variable of length X, this will be trim size;
	name = Player; 
	put Player;  *coerces Quartersbacks into character match down in sql;
run;
data RB_3;
	set RB_ADP;
	adp_pred = _N_;
	length name $8;
	name = TMName;
	put TMName;
run;


*joins the nfl players based on their trimmed names;
proc sql;
	create table combine2 as
	select * from RB_3, RB_2, RB_1
	where 
	RB_1.name = RB_2.name = RB_3.name;
quit;



proc print data = combine2;
run;

proc corr data = combine2;
	var predict result adp_pred;
run;
