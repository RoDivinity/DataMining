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

1.  Preprocessing data: Even though the data set contains nearly 1900 variables from five major categories collected from 7149 colleges, some of them have missing values due to unavailability of information, privacy policies and change in definitions over time. I will filter out these variables if they have over 85% of values which are missing. Next, I will filter out colleges with more than 10% of variables with missing values (these colleges can be too small, undergo fiscal problems or choose not to disclose vital information). The filter is necessary to make the data less noisy and counterproductive. Remaining categorical variables will be splitted into new columns explained by expository data dictionary maintained by U.S. Department of Education. Since not all variables are reported for 1051 colleges, I need to impute the data set following Don Rubin and Roderick Little suggested methods (Rubin and Little, 2002). Data are missing at random because for some colleges, the variables are reported, but not for others. The missing values after filtering out unreported variables and colleges are only 6.74% of the data but the process of imputation will be long due to robustness in imputation method. I do not utilize mean, mode or median to replace missing values because it reduces variance in data set and distorts the distributions of the variables. Other simple methods like using linear regressions to predict missing values are quick but they introduce bias and incapable of handling categorical variables (Rubin, 2002). In this project, I will utilize miss ranger method, an improvement of random forest algorithm in predicting missing values. It is reasonable efficient in computing time and handling both discrete and continuous variables. Due to file constraints, I must comment out my data preprocessing codes and export all imputed data as inputs for Rmarkdown to knit.

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
| 2010 |     0.7435929    |     0.6235152    |

The K-fold cross validation's RMSE of featured regression is smaller compated to that of suggested model in economic literature. This result strengthens the support of adding these features to final model.

Stability across time

| year | reg\_err\_save | lasso\_err\_save |
|:----:|:--------------:|:----------------:|
| 2010 |    0.5483981   |     0.3714839    |
| 2012 |    0.5614284   |     0.4885287    |
| 2013 |    0.5593955   |     0.4138776    |
| 2014 |    0.6025150   |     0.4718497    |

The results of linear model from selected variables outperform suggested model adapt from labor economics literature, these features should be included to measures of school quality. Students and parents, and general public should consider these factors too when comparing schools and considering attending colleges.

However, the regression model on selected features are less stable compared to suggested model from labor economics literature

The coefficients estimates of two linear models:

-   Black and Smith's suggested model

|             | coefficients.Estimate | coefficients.Std..Error | coefficients.t.value | coefficients.Pr...t.. |
|-------------|:----------------------|:------------------------|:---------------------|:----------------------|
| (Intercept) | 1.8461199             | 0.2998368               | 6.1570821            | 0.0000000             |
| AVGFACSAL   | 0.0001654             | 0.0000161               | 10.2696393           | 0.0000000             |
| RET\_FT4    | 0.0223989             | 0.1819445               | 0.1231087            | 0.9020447             |
| SAT\_AVG    | -0.0017185            | 0.0003630               | -4.7336921           | 0.0000025             |

-   Model from selected features

|                                     | coefficients.Estimate | coefficients.Std..Error | coefficients.t.value | coefficients.Pr...t.. |
|-------------------------------------|:----------------------|:------------------------|:---------------------|:----------------------|
| (Intercept)                         | -0.2960251            | 0.3835795               | -0.7717439           | 0.4404430             |
| PCIP12                              | -0.7535147            | 0.3391333               | -2.2218837           | 0.0265076             |
| PCIP46                              | 2.5921968             | 1.3795683               | 1.8789912            | 0.0605276             |
| COMP\_2YR\_TRANS\_YR2\_RT           | 5.4042106             | 6.9428576               | 0.7783842            | 0.4365212             |
| IND\_WDRAW\_2YR\_TRANS\_YR2\_RT     | -6.1459422            | 2.3996489               | -2.5611839           | 0.0105730             |
| NOPELL\_WDRAW\_4YR\_TRANS\_YR2\_RT  | -1.5439770            | 1.4191526               | -1.0879571           | 0.2768683             |
| COMP\_2YR\_TRANS\_YR3\_RT           | 3.8816810             | 5.3284422               | 0.7284833            | 0.4664832             |
| UNKN\_4YR\_TRANS\_YR4\_RT           | -0.4147358            | 3.1899740               | -0.1300123           | 0.8965821             |
| DEP\_ENRL\_2YR\_TRANS\_YR4\_RT      | 5.1355197             | 2.6095322               | 1.9679848            | 0.0493375             |
| LO\_INC\_COMP\_2YR\_TRANS\_YR6\_RT  | 1.1708234             | 4.3950683               | 0.2663948            | 0.7899884             |
| LOAN\_UNKN\_ORIG\_YR6\_RT           | 8.4113077             | 1.3819711               | 6.0864572            | 0.0000000             |
| FIRSTGEN\_COMP\_2YR\_TRANS\_YR6\_RT | 14.9282394            | 3.8827292               | 3.8447799            | 0.0001281             |
| DEP\_WDRAW\_2YR\_TRANS\_YR8\_RT     | -10.8321050           | 1.7980359               | -6.0244099           | 0.0000000             |
| IND\_WDRAW\_2YR\_TRANS\_YR8\_RT     | 1.9999608             | 2.2504898               | 0.8886780            | 0.3743834             |
| PELL\_WDRAW\_4YR\_TRANS\_YR8\_RT    | 4.0151942             | 0.8693163               | 4.6187954            | 0.0000043             |
| IND\_INC\_PCT\_H2                   | -13.7940529           | 1.9715573               | -6.9965265           | 0.0000000             |
| GT\_25K\_P6                         | 2.0984442             | 0.2857547               | 7.3435162            | 0.0000000             |
| AVGFACSAL                           | 0.0001065             | 0.0000147               | 7.2288391            | 0.0000000             |
| SAT\_AVG                            | -0.0009601            | 0.0003652               | -2.6293583           | 0.0086820             |
| RET\_FT4                            | 0.2468722             | 0.1728616               | 1.4281496            | 0.1535516             |

From the two coefficients tables, we observe that average faculty salary (represents colleges' input) and average SAT score (represents selectivity) are statistically significant. Both models agree on the same effects of the two measures, with more spending on faculty enhance financial returns of attending colleges for students (improve teaching quality) and the more selective a college, the less return students received in future earnings. There are two hypotheses can account for this phenomenon. Elite schools have high tuition and living costs due to their popularity, but earnings by cohorts do not compensate for the high price, or attending a lower cost, less selective college to obtain a degree promise better return. Besides, the suggested measure of "voting with your feet" freshman retention rate is not statistically significant. This can be explained by selected features: the measure of college preference is decomposed to students' transfer movements across 2-year, 3-year and 4-year colleges, whether they completed or drop out of these transferred institutions and their background (Title IV, Pell Grant recipients, first generations to go to college, low income families). The completion rate of colleges are important, implying complete program in colleges increase future earning of workers by improving their qualities and skills. Other noisy variables have been filtered out are geographical locations, control of institution (public/private/non-profit), gender and race of students. These seemingly important factors turn out to have negligible to zero effect on financial return of attending colleges

Conclusions
===========

The selected features from data mining concludes that SAT score (measures of colleges’ selectivity), the freshman retainment rate (measures of students’ preferences with the colleges) and average faculty salary (measures of colleges’ inputs into education) are deciding factors in determining college qualities. The return on education increases with the percentage of students who received Pell Grant then transfer to 4-year colleges. Interestingly, the contrary is true, too. Students who receives aids but transfer out of the institutions after 8 years implying an adverse outcome on return on colleges. This can be explained by students' preference of colleges. College students with financial struggle will either make the best use of Title IV loans to transfer to better universities or rely on the loan and do not complete degree or dropout. Loan status, transfer movement and withdrawals of student body (transfer out to 2-year or 4-year institutions) tends to significantly explain and predict the return of attending a college. Other factors such as majors, degree types, racial, gender and age distribution of the cohort, and control of an institution(public or private) does not impact the financial return as many students and parents worried. These are accomplishments deserved to be lauded: student loans are effective, but only if the students utilize them. Gender, races, and age are equal in financial returns of attending colleges (The estimates from LASSO regression are 0 and filtered out by regularization process, implying no impact on the outcomes based on 2010 data). In my projects, I have not addressed the existence of endogeneity. It may introduce bias to the estimates. However, this is not my primary objective. In this project, my aim is to select a set of meaningful features to help users focus on using the colleges' statistics, a publicly available dataset but often neglected by general public. The features selected will make the data readable to interested audience, indicating users of the more relevant characteristics out of more than 1800 noisy variables. It also provides simple, intuitive understanding of these variables, with positive, negative magnitude represents whether the variables are good or bad in picking colleges. College students and parents can easily predict the average expected financial returns of attending amongst colleges by using the estimates of the variables.

Reference
=========

1.  Black, D. A. & Smith, J. A. (2004): How robust is the effects of college quality? Evidence from matching. Journal of Econometrics, vol. 121, 99-124

2.  Card, D. & Krueger, A. B. (1996): Labor market effects of school quality: Theory and Evidence. NEBR Working Paper, 5450.

3.  Rubin, D. A. & Little, R. J. A. (2002): Statistical analysis with missing data (2nd edition). Wiley Series in Probabilities and Statistics. <DOI:10.1002/9781119013563>
