data problem3;
	input Degree$	Newspaper$ Gender $	Count;
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


 proc logistic data = problem3 order=data;
 class Degree Gender/param = ref;
 freq count;
 model Newspaper= Degree gender/link=clogit aggregate scale=none ;
 output out = prob PREDPROBS=I;
run;


data prob32;
	set problem3;
	if Newspaper = 1 |2 |3 | 4 then Once = 1;
	if Newspaper = 5 then Once = 0;
run;

proc print data = prob32;
run;


 proc logistic data = prob32 order=data;
 class Degree Gender/param = ref;
 freq count;
 model Once= Degree gender/link=clogit aggregate scale=none ;
 output out = prob PREDPROBS=I;
run;
