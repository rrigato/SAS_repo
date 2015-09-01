PROC IMPORT OUT= WORK.WR_result 

           DATAFILE= "C:\Users\Punkiehome1\Downloads\2014 BFL WR Results.csv"  
	            DBMS=csv	REPLACE;
			  DATAROW=2; 	
     GETNAMES=YES;
RUN;


PROC IMPORT OUT= WORK.WR_predict 
            DATAFILE= "C:\Users\Punkiehome1\Downloads\predict4.csv" 
            DBMS=CSV REPLACE;
			 DATAROW=2; 
     GETNAMES=YES;
RUN;

PROC IMPORT OUT= WORK.WR_ADP 
            DATAFILE= "C:\Users\Punkiehome1\Downloads\WR_2014ADP.csv" 
            DBMS=CSV REPLACE;
			 DATAROW=2; 
     GETNAMES=YES;
RUN;


data WR_1;
	set WR_result;
	result = _N_;
	length name $9;
	name = Player;
	put Player;
	drop Player;
	drop Team;
run;


data WR_2;
	set WR_predict;
	drop var12;
	drop var16--var28;
	predict = _N_;
	length name $9;   *declares a character variable of length X, this will be trim size;
	name = Player; 
	put Player;  *coerces Quartersbacks into character match down in sql;
	drop Player;
run;
data WR_3;
	set WR_ADP;
	adp_pred = _N_;
	length name $9;
	name = TMName;
	put TMName;
run;


*joins the nfl players based on their trimmed names;
proc sql;
	create table combine3 as
	select * from WR_3 , WR_2 , WR_1
	where 
	WR_1.name = WR_2.name = WR_3.name;
quit;





proc corr data = combine3;
	var predict result adp_pred;
run;

proc print data = combine3;
	var TMName predict adp_pred result;
run;
