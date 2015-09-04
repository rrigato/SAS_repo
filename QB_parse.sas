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



