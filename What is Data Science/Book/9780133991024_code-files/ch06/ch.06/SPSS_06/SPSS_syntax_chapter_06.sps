﻿
DATASET ACTIVATE DataSet1.

* Table 6.2

SUMMARIZE
  /TABLES=eval age beauty students allstudents
  /FORMAT=NOLIST TOTAL
  /TITLE='Case Summaries'
  /MISSING=VARIABLE
  /CELLS=COUNT MEAN STDDEV SEMEAN.

* Figure 6.8

GGRAPH
  /GRAPHDATASET NAME="graphdataset"
    VARIABLES=eval[LEVEL=scale] 
    MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=VIZTEMPLATE(NAME="Histogram"[LOCATION=LOCAL]
    MAPPING( "x"="eval"[DATASET="graphdataset"] "Summary"="count"))
    VIZSTYLESHEET="Traditional"[LOCATION=LOCAL]
    LABEL='HISTOGRAM: eval'
    DEFAULTTEMPLATE=NO.

* Figure 6.9

COMPUTE norm_eval=(eval-3.998)/.554.
EXECUTE.

GGRAPH
  /GRAPHDATASET NAME="graphdataset"
    VARIABLES=norm_eval[LEVEL=scale] 
    MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=VIZTEMPLATE(NAME="Histogram"[LOCATION=LOCAL]
    MAPPING( "x"="norm_eval"[DATASET="graphdataset"] "Summary"="count"))
    VIZSTYLESHEET="Traditional"[LOCATION=LOCAL]
    LABEL='HISTOGRAM: norm_eval'
    DEFAULTTEMPLATE=NO.


* Table 6.5

SUMMARIZE
  /TABLES=eval BY gender
  /FORMAT=NOLIST TOTAL
  /TITLE='Case Summaries'
  /MISSING=VARIABLE
  /CELLS=MEAN STDDEV.

* Figure 6.26 Fig. 6.30, and Fig. 6.35

T-TEST GROUPS=gen2(1 2)
  /MISSING=ANALYSIS
  /VARIABLES=eval
  /CRITERIA=CI(.95).

* Figure 6.36

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT eval
  /METHOD=ENTER gen2.

* Figure 6.37

SPSSINC CREATE DUMMIES VARIABLE=age_cat 
ROOTNAME1=newage 
/OPTIONS ORDER=A USEVALUELABELS=YES USEML=YES OMITFIRST=NO.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT eval
  /METHOD=ENTER newage_2 newage_3.

* Figure 6.38

ONEWAY eval BY age_cat
  /MISSING ANALYSIS.

* Figure 6.39

ONEWAY eval BY beauty_cat
  /MISSING ANALYSIS.

* Figure 6.40

CROSSTABS
  /TABLES=gender BY tenure
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT ROW 
  /COUNT ROUND CELL.