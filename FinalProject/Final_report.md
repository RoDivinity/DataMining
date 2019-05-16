Abstract
========

It is a common concern for students and parents to choose which colleges to attend and send their kids to. A large body of labor economics literature explains and quantifies that individuals’ education quality affects the workers’ productivity (measure by wages), proving that colleges’ choice matter to students’ future (Card and Krueger, 1996). Besides common features like average faculty salary, ratio of faculty to student, instructional expenditure per student, what else students and parents should look at to know if attending a particular college worth their pennies? My project aims to use LASSO regression to select more colleges’ features from the College Scorecard database to guide students and parents to the most relevant and impactful indicators of a quality college. Furthermore, my model will testify if the proposed measures of college quality in current labor economics are consistent in capturing return on education. The result from 2010 data proves that selectivity and colleges’ expenditure on education (Black and Smith, 2004) are statistically significant and relevant. The set of selected features also recommends these measures, in addition with measures of income earning cohorts, distribution of students’ family income and federal aid status. My simple linear model resulted from LASSO regression’s selected features perform stably through 2012 to 2014 data. The uncertainty of the model is lower than that of Black and Smith suggestion of measuring college’s quality. A few insights I obtain from two models and their predictions are geographical locations and regions, gender, race and age of student body and completion time taken to graduate have miniscule effects on financial returns of attending colleges.

Introduction
============

Labor economics literature proves that school quality relates to students’ subsequent labor market success. Card and Krueger (Card et. al., 1996) published significant result indicating varying school quality determines individuals’ schooling and future earnings. High school students and parents concerns with choice of school because majority of public attends colleges to secure a finer career with higher paying jobs and greater employment opportunities. Understand this issue, U.S. Department of Education collects, organizes and publishes valuable statistics about entire lists of U.S. post-secondary schools, majority of which are U.S. colleges and universities. The meaningful data is publicly available to retrieve from College Scorecard, a novel database attempting to increase transparency and broaden general information. However, the rich and detailed information provided in College Scorecard overwhelm any students, parents and researchers. Instead, students and parents rely on US News and other information providers to compare schools, while researchers resorting to social experiment, tedious information collecting processes, leaving the information to waste. This project aims to deduce financial returns of attending colleges using College Scorecard’s reported statistics. This is an important issue that matters to high school students to select colleges, parents to decide which colleges for their children’s education and compare its performance to prevailing labor economists’ model relating school qualities with return on education. By mining the data from College Scorecard to capture features that can forecast the future return on education, I want to answer the question that matters to students, parents and academic researchers interested in. Which characteristics of colleges are the most influential indicators for educational investment? After obtaining a set of selected characteristics, I will compare this set to the set of variables typically used in labor economics papers in measuring return on education. I will use Black and Smith’s model (2004) to benchmark my model since they conduct a more recent, verbose research on school quality on labor outcomes. Both models will reduce noise and minimize effort to interpret College Scorecard, by indicating which features matter most in looking at colleges, rendering comprehensive information to broader audience. Only then, the data will be useful to students, parents and researchers who now are informed which variables to attend to when researching a college, and relative estimates of their impacts on colleges’ payoff in job market.

Methods
=======

Brief description of the data set
---------------------------------

College Scorecard published by U.S Department of Education contains college statistics collected from 7416 US colleges, with 1898 variables associated with each college, starting from 1996-1997 cohort to the latest 2016-2017 cohort. The data set measures five major areas of colleges: earnings, completion rate, cost, debt and repayment and access, with each categories sub-divided into racial groups, income quantiles, gender, study fields and various relevant categorical factors

Methodology
-----------

1.  Preprocessing data: Even though the data set contains nearly 1900 variables from five major categories collected from 7149 colleges, some of them have missing values due to unavailability of information, privacy policies and change in definitions over time. I will filter out these variables if they have over 85% of values which are missing. Next, I will filter out colleges with more than 10% of variables with missing values (these colleges can be too small, undergo fiscal problems or choose not to disclose vital information). The filter is necessary to make the data less noisy and counterproductive. Remaining categorical variables will be splitted into new columns explained by expository data dictionary maintained by U.S. Department of Education. Since not all variables are reported for 1051 colleges, I need to impute the data set following Don Rubin (Statistical Inference of Missing Values, 2002) methods. Data are missing at random because for some colleges, the variables are reported, but not for others. The missing values after filtering out unreported variables and colleges are only 6.74% of the data but the process of imputation will be long due to robustness in imputation method. I do not utilize mean, mode or median to replace missing values because it reduces variance in data set and distorts the distributions of the variables. Other simple methods like using linear regressions to predict missing values are quick but they introduce bias and incapable of handling categorical variables (Rubin, 2002). In this project, I will utilize miss ranger method, an improvement of random forest algorithm in predicting missing values. It is reasonable efficient in computing time and handling both discrete and continuous variables. Due to file constraints, I must comment out my data preprocessing codes and export all imputed data as inputs for Rmarkdown to knit.

2.  Regularize data: To analyze the data, I will generate an independent variable, named RETURN. The variable is computed by using the average income earned by former students minus the cost of attendance divided by the cost of attendance reported in the data. The variable carries the similar measure of return on education primarily used in labor economics literature. It also an indicator to address the question concerned students and parents, which school is the best bang for the buck. I will use the mean earnings of students working and not enrolled 6 years after entry (MN\_EARN\_WNE\_P6) as reference for potential earnings and average anual total cost of attendance (COSTT4\_A) as reference for cost of attendance. To make the data intepretable, I will deploy Lasso regression to eliminate unnecessary variables in the data from the filtered variables after data preprocessing. The first step is to create a sparse matrix to handle multiple categorical variables (geographical locations, cohort gender, race, Title IV status, etc). After building design matrix, I run Lasso regression from gamlr library and extract out variables in the Lasso regression impacting the return on education. Then I rerun obtained features as targeted regression model explaining the return on education. For data from year 2012 to 2014, I use selected features from LASSO regressions to subset the data and impute missing values again, then predict the outcomes for the simple linear regression model obtained above.

3.  Benchmark test: I will use simpler, more common regression of school quality on return on education based on labor economics literature with selected features of the data set. In this paper, I will adopt Black and Smith suggested regression model (Black and Smith, 105) as a benchmark. Average SAT, average faculty salary, average freshman retention rate are used to predict school quality. Based on common observations, a higher quality school associate with higher income earned by graduates (Black et. al., 109). The explanatory features are explained as follows: SAT scores measure selectivity (peer quality), average faculty salary measure degree school investment to students, and freshman retention rate represents “voting with your feet” measures (Black et. al., 105). Based on this econometric model to measure school quality matching with students’ future earning, I used variables: AVGFACSAL: average faculty salary SAT\_AVG: average SAT scores of admissions RET\_FT4: first-time, full-time student retention rate at four-year institutions The econometric model to benchmark is: RETURN ~ AVGFACSAL + SAT\_AVG + RET\_FT4

4.  Uncertainty and stability comparison and model interpretations: I intend to test the two models on consecutive years to guarantee its stability and predictive power. To examine the model uncertainty, I will conduct K-fold cross validation for 2010 data set, on both suggested model by Black and linear regression with LASSO selected features. For year 2012-2014, I will subset data to contain only selected features and redo imputation for all data set. If my model’s root mean squared error is relatively constant through one year to the next, the result implies my model is stable across time. The selected features are relevant and certain. If my model’s root mean squared error is relatively lower than Black and Smith model’s, the result implies the selected features are additional in practice to predict financial return of attending a particular college.

Results
=======

The numbers of features selected by LASSO regression with their absolute magnitudes exceeds a certain threshold.

|     |  1  |   2  |   3  |   4  |   5  |   6  |   7  |   8  |   9  |  10 |  11 |  12 |  13 |  14 |  15 |  16 |
|-----|:---:|:----:|:----:|:----:|:----:|:----:|:----:|:----:|:----:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| i   |  0  |  0.1 |  0.2 |  0.3 |  0.4 |  0.5 |  0.6 |  0.7 |  0.8 | 0.9 |  1  | 1.1 | 1.2 | 1.3 | 1.4 | 1.5 |
|     | 133 | 46.0 | 34.0 | 28.0 | 22.0 | 18.0 | 15.0 | 14.0 | 11.0 | 8.0 |  7  | 5.0 | 5.0 | 2.0 | 2.0 | 2.0 |

I balance between complexity of predictive model and complexity of regression variables (number of variables in the simple linear regression. I pick the absolute magnitude of beta coefficients in LASSO regression to be larger than 0.5. The simple regression from the selected features are:

    ## RETURN ~ PCIP12 + PCIP46 + COMP_2YR_TRANS_YR2_RT + IND_WDRAW_2YR_TRANS_YR2_RT + 
    ##     NOPELL_WDRAW_4YR_TRANS_YR2_RT + COMP_2YR_TRANS_YR3_RT + UNKN_4YR_TRANS_YR4_RT + 
    ##     DEP_ENRL_2YR_TRANS_YR4_RT + LO_INC_COMP_2YR_TRANS_YR6_RT + 
    ##     LOAN_UNKN_ORIG_YR6_RT + FIRSTGEN_COMP_2YR_TRANS_YR6_RT + 
    ##     DEP_WDRAW_2YR_TRANS_YR8_RT + IND_WDRAW_2YR_TRANS_YR8_RT + 
    ##     PELL_WDRAW_4YR_TRANS_YR8_RT + IND_INC_PCT_H2 + GT_25K_P6 + 
    ##     AVGFACSAL + SAT_AVG + RET_FT4

With reference to the data dictionary supplied by U.S Department of Education, the following features related to return on attending colleges: a. Percentage of degrees awarded in different fields (PCIP12 and PCIP46 represent Personal and Culinary Services) b. Completion of colleges (root COMP stands for completion, with suffix XYR\_TRANS\_YR2\_RT refer to percentage of students transferred to X-year institution and completed them within Y year) c. Transfer movement of students (suffix TRANS\_YRX refer to transfer to X year institutions, while prefex LO\_INC, DEP\_ENRL, FIRSTGEN, PELL indicates low income, dependent, first generation, TitleIV and Pell Grant received students attending colleges) d. Percentage of students earning over $25000/year 6 years after entered college

Test for uncertainty of the model using 2010 data, compared to the benchmark model

| year | sug\_model\_RMSE | sel\_model\_RMSE |
|:----:|:----------------:|:----------------:|
| 2010 |     0.7427339    |     0.6250714    |

Stability across time

| year | reg\_err\_save | lasso\_err\_save |
|:----:|:--------------:|:----------------:|
| 2010 |    0.5483981   |     0.3714839    |
| 2012 |    0.5614284   |     0.4885287    |
| 2013 |    0.5593955   |     0.4138776    |
| 2014 |    0.6025150   |     0.4718497    |

The results of linear model from selected variables outperform suggested model adapt from labor economics literature, these features should be included to measures of school quality. Students and parents, and general public should consider these factors too when comparing schools and considering attending colleges

The coefficients estimates of two linear models:

1.  Black and Smith's suggested model

<!-- -->

    ## $coefficients
    ##                  Estimate   Std. Error    t value     Pr(>|t|)
    ## (Intercept)  1.8461198783 2.998368e-01  6.1570821 1.054314e-09
    ## AVGFACSAL    0.0001653821 1.610399e-05 10.2696393 1.221718e-23
    ## RET_FT4      0.0223989428 1.819445e-01  0.1231087 9.020447e-01
    ## SAT_AVG     -0.0017185211 3.630403e-04 -4.7336921 2.507342e-06

1.  Model from selected features

<!-- -->

    ## $coefficients
    ##                                     Estimate   Std. Error    t value
    ## (Intercept)                    -2.960251e-01 3.835795e-01 -0.7717439
    ## PCIP12                         -7.535147e-01 3.391333e-01 -2.2218837
    ## PCIP46                          2.592197e+00 1.379568e+00  1.8789912
    ## COMP_2YR_TRANS_YR2_RT           5.404211e+00 6.942858e+00  0.7783842
    ## IND_WDRAW_2YR_TRANS_YR2_RT     -6.145942e+00 2.399649e+00 -2.5611839
    ## NOPELL_WDRAW_4YR_TRANS_YR2_RT  -1.543977e+00 1.419153e+00 -1.0879571
    ## COMP_2YR_TRANS_YR3_RT           3.881681e+00 5.328442e+00  0.7284833
    ## UNKN_4YR_TRANS_YR4_RT          -4.147358e-01 3.189974e+00 -0.1300123
    ## DEP_ENRL_2YR_TRANS_YR4_RT       5.135520e+00 2.609532e+00  1.9679848
    ## LO_INC_COMP_2YR_TRANS_YR6_RT    1.170823e+00 4.395068e+00  0.2663948
    ## LOAN_UNKN_ORIG_YR6_RT           8.411308e+00 1.381971e+00  6.0864572
    ## FIRSTGEN_COMP_2YR_TRANS_YR6_RT  1.492824e+01 3.882729e+00  3.8447799
    ## DEP_WDRAW_2YR_TRANS_YR8_RT     -1.083210e+01 1.798036e+00 -6.0244099
    ## IND_WDRAW_2YR_TRANS_YR8_RT      1.999961e+00 2.250490e+00  0.8886780
    ## PELL_WDRAW_4YR_TRANS_YR8_RT     4.015194e+00 8.693163e-01  4.6187954
    ## IND_INC_PCT_H2                 -1.379405e+01 1.971557e+00 -6.9965265
    ## GT_25K_P6                       2.098444e+00 2.857547e-01  7.3435162
    ## AVGFACSAL                       1.065232e-04 1.473586e-05  7.2288391
    ## SAT_AVG                        -9.601262e-04 3.651561e-04 -2.6293583
    ## RET_FT4                         2.468722e-01 1.728616e-01  1.4281496
    ##                                    Pr(>|t|)
    ## (Intercept)                    4.404430e-01
    ## PCIP12                         2.650762e-02
    ## PCIP46                         6.052761e-02
    ## COMP_2YR_TRANS_YR2_RT          4.365212e-01
    ## IND_WDRAW_2YR_TRANS_YR2_RT     1.057297e-02
    ## NOPELL_WDRAW_4YR_TRANS_YR2_RT  2.768683e-01
    ## COMP_2YR_TRANS_YR3_RT          4.664832e-01
    ## UNKN_4YR_TRANS_YR4_RT          8.965821e-01
    ## DEP_ENRL_2YR_TRANS_YR4_RT      4.933746e-02
    ## LO_INC_COMP_2YR_TRANS_YR6_RT   7.899884e-01
    ## LOAN_UNKN_ORIG_YR6_RT          1.625809e-09
    ## FIRSTGEN_COMP_2YR_TRANS_YR6_RT 1.280513e-04
    ## DEP_WDRAW_2YR_TRANS_YR8_RT     2.358971e-09
    ## IND_WDRAW_2YR_TRANS_YR8_RT     3.743834e-01
    ## PELL_WDRAW_4YR_TRANS_YR8_RT    4.347158e-06
    ## IND_INC_PCT_H2                 4.715800e-12
    ## GT_25K_P6                      4.218255e-13
    ## AVGFACSAL                      9.473373e-13
    ## SAT_AVG                        8.681956e-03
    ## RET_FT4                        1.535516e-01

From the two coefficients tables, we observe that average faculty salary (represents colleges' input) and average SAT score (represents selectivity) are statistically significant. Both models agree on the same effects of the two measures, with more spending on faculty enhance financial returns of attending colleges for students (improve teaching quality) and the more selective a college, the less return students received in future earnings. There are two hypotheses can account for this phenomenon. Elite schools have high tuition and living costs due to their popularity, but earnings by cohorts do not compensate for the high price, or attending a lower cost, less selective college to obtain a degree promise better return. Besides, the suggested measure of "voting with your feet" freshman retention rate is not statistically significant. This can be explained by selected features: the measure of college preference is decomposed to students' transfer movements across 2-year, 3-year and 4-year colleges, whether they completed or drop out of these transferred institutions and their background (Title IV, Pell Grant recipients, first generations to go to college, low income families). The completion rate of colleges are important, implying complete program in colleges increase future earning of workers by improving their qualities and skills. Other noisy variables have been filtered out are geographical locations, control of institution (public/private/non-profit), gender and race of students. These seemingly important factors turn out to have negligible to zero effect on financial return of attending colleges

Conclusions
===========

The selected features from data mining concludes that SAT score (measures of colleges’ selectivity), the freshman retainment rate (measures of students’ preferences with the colleges) and average faculty salary (measures of colleges’ inputs into education) are deciding factors in determining college qualities. The return on education increases with the percentage of students who received Pell Grant then transfer to 4-year colleges. Interestingly, the contrary is true, too. Students who receives aids but transfer out of the institutions after 8 years implying an adverse outcome on return on colleges. This can be explained by students' preference of colleges. College students with financial struggle will either make the best use of Title IV loans to transfer to better universities or rely on the loan and do not complete degree or dropout. Loan status, transfer movement and withdrawals of student body (transfer out to 2-year or 4-year institutions) tends to significantly explain and predict the return of attending a college. Other factors such as majors, degree types, racial, gender and age distribution of the cohort, and control of an institution(public or private) does not impact the financial return as many students and parents worried. These are accomplishments deserved to be lauded: student loans are effective, but only if the students utilize them. Gender, races, and age are equal in financial returns of attending colleges (The estimates from LASSO regression are 0 and filtered out by regularization process, implying no impact on the outcomes based on 2010 data). In my projects, I have not addressed the existence of endogeneity. It may introduce bias to the estimates. However, this is not my primary objective. In this project, my aim is to select a set of meaningful features to help users focus on using the colleges' statistics, a publicly available dataset but often neglected by general public. The features selected will make the data readable to interested audience, indicating users of the more relevant characteristics out of more than 1800 noisy variables. It also provides simple, intuitive understanding of these variables, with positive, negative magnitude represents whether the variables are good or bad in picking colleges. College students and parents can easily predict the average expected financial returns of attending amongst colleges by using the estimates of the variables.
