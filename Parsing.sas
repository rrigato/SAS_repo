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


data RB_1;
	set RB_result;
	result = _N_;
	length name $8;
	name = Player;
	put Player;
run;


data RB_2;
	set RB_predict;
	predict = _N_;
	length name $8;   *declares a character variable of length X, this will be trim size;
	name = Running; 
	put Running;  *coerces Quartersbacks into character match down in sql;
run;



*joins the nfl players based on their trimmed names;
proc sql;
	create table combine2 as
	select * from RB_2 
	inner join RB_1
	on 
	RB_2.name = RB_1.name;
quit;



proc print data = combine2;
run;

proc corr data = combine2;
	var predict result;
run;
