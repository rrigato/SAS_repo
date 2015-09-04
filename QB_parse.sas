PROC IMPORT OUT= WORK.QB_result 

           DATAFILE= "C:\Users\Punkiehome1\Downloads\2014 BFL QB result
s.csv"  
	            DBMS=csv	REPLACE;
				
     GETNAMES=YES;
     DATAROW=2; 
RUN;


PROC IMPORT OUT= WORK.QB_predict 
            DATAFILE= "C:\Users\Punkiehome1\Downloads\predict2.csv" 
            DBMS=CSV REPLACE;
			 DATAROW=2; 
     GETNAMES=YES;

RUN;

PROC IMPORT OUT= WORK.QB_ADP 
            DATAFILE= "C:\Users\Punkiehome1\Downloads\QB_2014ADP.csv" 
            DBMS=CSV REPLACE;
			 DATAROW=2; 
     GETNAMES=YES;
RUN;


data QB_1;
	set QB_result;
	result = _N_;

	length name $8;
	name = Player1;
	put Player1;
run;


data QB_2;
	set QB_predict;
	predict = _N_;
	length name $8;   *declares a character variable of length X, this will be trim size;
	name = Quarterbacks; 
	put Quarterbacks;  *coerces Quartersbacks into character match down in sql;
run;

data QB_3;
	set QB_ADP;
	adp_pred = _N_;
	length name $9;
	name = TMName;
	put TMName;
run;




*joins the nfl players based on their trimmed names;
proc sql;
	create table combine as
	select * from QB_1, QB_2, QB_3
	where 
	QB_1.name = QB_2.name = QB_3.name;
quit;



proc print data = combine;
run;

proc corr data = combine;
	var predict result;
run;
