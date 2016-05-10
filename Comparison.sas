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
proc glm data = f142;
	class Gender;
	model SWeek = Extroversion Intelligence Age Gender / solution clm;
	output out = myout r = res lclm=lowCI uclm=upCI;
run;

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
