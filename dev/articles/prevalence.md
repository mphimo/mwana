# Estimating the prevalence of wasting

## Introduction

This vignette demonstrates the use of `mwana` package’s functions to
estimate the prevalence of wasting based on:

- Weight-for-height z-score (WFHZ) and/or oedema
- Raw MUAC values and/or oedema
- MUAC-for-age z-score (MFAZ) and/or oedema, and
- Combined prevalence.

The prevalence functions in `mwana` were carefully conceived and
designed to simplify the workflow of a nutrition data analyst,
especially when dealing with datasets containing imperfections that
require additional layers of analysis. Let’s try to clarify this with
two scenarios that I believe will remind you of the alluded complexity:

- When analysing a multi-area dataset, users will likely need to
  estimate the prevalence for each area individually. Afterward, they
  must extract the results and collate in a summary table for sharing.

- When working with MUAC data, when age ratio test is rated as
  problematic, an additional tool is required to weight the prevalence
  and correct for age bias, thereby the associated likely prevalence
  overestimation. In an unfortunate cases wherein multiple areas face
  this issue, the workflow must be repeated several times, making the
  process cumbersome, boredom, and highly error-prone.

With `mwana`, you no longer have to worry about this 🥳. The functions
are designed to deal with that. To demonstrate their use, we will use
different datasets to represent different scenarios:

- `anthro.02` : a survey data with survey weights. Learn more about this
  data with
  [`?anthro.02`](https://mphimo.github.io/mwana/dev/reference/anthro.02.md).
- `anthro.03` : district-level SMART surveys with two districts whose
  WFHZ standard deviations are rated as problematic while the rest lay
  within range. Do
  [`?anthro.03`](https://mphimo.github.io/mwana/dev/reference/anthro.03.md)
  for more details.
- `anthro.04` : a community-based sentinel site data. The data has
  different characteristics that require different analysis approaches.

## Estimation of the prevalence of wasting based on WFHZ

To estimate the prevalence of wasting based on WFHZ we use the
[`mw_estimate_prevalence_wfhz()`](https://mphimo.github.io/mwana/dev/reference/mw_estimate_prevalence_wfhz.md)
function. The dataset to supply must have been wrangled by
[`mw_wrangle_wfhz()`](https://mphimo.github.io/mwana/dev/reference/mw_wrangle_wfhz.md).

As usual, we start off by inspecting our dataset:

``` r
tail(anthro.02)
```

    #> # A tibble: 6 × 14
    #>   province strata cluster   sex   age weight height oedema  muac wtfactor   wfhz
    #>   <chr>    <chr>    <int> <dbl> <dbl>  <dbl>  <dbl> <chr>  <dbl>    <dbl>  <dbl>
    #> 1 Nampula  Urban      285     1  59.5   13.8   90.7 n        149     487.  0.689
    #> 2 Nampula  Rural      234     1  59.5   17.2  105.  n        193    1045.  0.178
    #> 3 Nampula  Rural      263     1  59.6   18.4  100   n        156     952.  2.13
    #> 4 Nampula  Rural      257     1  59.7   15.9  100.  n        149     987.  0.353
    #> 5 Nampula  Rural      239     1  59.8   12.5   91.5 n        135     663. -0.722
    #> 6 Nampula  Rural      263     1  60.0   14.3   93.8 n        142     952.  0.463
    #> # ℹ 3 more variables: flag_wfhz <dbl>, mfaz <dbl>, flag_mfaz <dbl>

We can see that the dataset contains the required variables for a WFHZ
prevalence analysis, including for a weighted analysis. This dataset has
already been wrangled, therefore there is no need to call the WFHZ
wrangler.

### Estimation of unweighted prevalence

To achieve this we do:

``` r
anthro.02 |>
  mw_estimate_prevalence_wfhz(
    wt = NULL,
    oedema = oedema
  )
```

This will return:

    #> # A tibble: 1 × 16
    #>   gam_n  gam_p gam_p_low gam_p_upp gam_p_deff sam_n   sam_p sam_p_low sam_p_upp
    #>   <dbl>  <dbl>     <dbl>     <dbl>      <dbl> <dbl>   <dbl>     <dbl>     <dbl>
    #> 1    86 0.0408    0.0322    0.0494        Inf    14 0.00664   0.00273    0.0106
    #> # ℹ 7 more variables: sam_p_deff <dbl>, mam_n <dbl>, mam_p <dbl>,
    #> #   mam_p_low <dbl>, mam_p_upp <dbl>, mam_p_deff <dbl>, wt_pop <dbl>

If for some reason the variable oedema is not available in the dataset,
or it’s there but not plausible, we can exclude it from the analysis by
setting the argument `oedema` to `NULL`:

``` r
anthro.02 |>
  mw_estimate_prevalence_wfhz(
    wt = NULL,
    oedema = NULL # Setting oedema to NULL
  )
```

And we get:

    #> # A tibble: 1 × 16
    #>   gam_n  gam_p gam_p_low gam_p_upp gam_p_deff sam_n sam_p sam_p_low sam_p_upp
    #>   <dbl>  <dbl>     <dbl>     <dbl>      <dbl> <dbl> <dbl>     <dbl>     <dbl>
    #> 1    72 0.0342    0.0263    0.0420        Inf     0     0         0         0
    #> # ℹ 7 more variables: sam_p_deff <dbl>, mam_n <dbl>, mam_p <dbl>,
    #> #   mam_p_low <dbl>, mam_p_upp <dbl>, mam_p_deff <dbl>, wt_pop <dbl>

If we inspect the `gam_n` and `gam_p` columns of this output table and
the previous, we notice differences in the numbers. This occurs because
oedema cases were excluded in the second implementation. It is
noteworthy that you will observe a change if there are positive cases of
oedema in the dataset; otherwise, setting `oedema = NULL` will have no
effect whatsoever.

The above output summary does not show results by province. We can
control this by supplying the variable or set of variables containing
the locations where the data was collected, or any other category (such
as teams, sex, etc.) after oedema. In our case, we will use the column
`province`:

``` r
anthro.02 |>
  mw_estimate_prevalence_wfhz(
    wt = NULL,
    oedema = oedema,
    province # province is the variable name holding data on where the survey was conducted.
  )
```

And *voila* :

    #> # A tibble: 2 × 17
    #>   province gam_n  gam_p gam_p_low gam_p_upp gam_p_deff sam_n   sam_p sam_p_low
    #>   <chr>    <dbl>  <dbl>     <dbl>     <dbl>      <dbl> <dbl>   <dbl>     <dbl>
    #> 1 Nampula     53 0.0546    0.0397    0.0695        Inf    10 0.0103  0.00282
    #> 2 Zambezia    33 0.0290    0.0195    0.0384        Inf     4 0.00351 0.0000639
    #> # ℹ 8 more variables: sam_p_upp <dbl>, sam_p_deff <dbl>, mam_n <dbl>,
    #> #   mam_p <dbl>, mam_p_low <dbl>, mam_p_upp <dbl>, mam_p_deff <dbl>,
    #> #   wt_pop <dbl>

A table with two rows is returned with each province’s statistics.

### Estimation of weighted prevalence

To get the weighted prevalence, we use the `wt` argument. We pass to it
the column name containing the final survey weights. In our case, the
column name is `wtfactor`:

``` r
anthro.02 |>
  mw_estimate_prevalence_wfhz(
    wt = wtfactor, # Passing the wtfactor to wt
    oedema = oedema,
    province
  )
```

And you get:

    #> # A tibble: 2 × 17
    #>   province gam_n  gam_p gam_p_low gam_p_upp gam_p_deff sam_n   sam_p sam_p_low
    #>   <chr>    <dbl>  <dbl>     <dbl>     <dbl>      <dbl> <dbl>   <dbl>     <dbl>
    #> 1 Nampula     53 0.0595    0.0410    0.0779       1.52    10 0.0129   0.00272
    #> 2 Zambezia    33 0.0261    0.0161    0.0361       1.16     4 0.00236 -0.000255
    #> # ℹ 8 more variables: sam_p_upp <dbl>, sam_p_deff <dbl>, mam_n <dbl>,
    #> #   mam_p <dbl>, mam_p_low <dbl>, mam_p_upp <dbl>, mam_p_deff <dbl>,
    #> #   wt_pop <dbl>

> **The work under the hood of `mw_estimate_prevalence_wfhz`**
>
> Under the hood, before it begins with the prevalence estimation, the
> function first checks the quality of the WFHZ standard deviation. If
> it is not problematic, it proceeds with a complex sample-based
> analysis; otherwise, prevalence is estimated applying the PROBIT
> method. This is as you see in the body of the plausibility report
> generated by ENA. The `anthro.02` dataset has no such issues, so you
> don’t see `mw_estimate_prevalence_wfhz` in action in this regard. To
> see that, let’s use the `anthro.03` dataset.

`anthro.03` contains problematic standard deviation in Metuge and
Maravia districts; the rest lay within range.

Let’s inspect our dataset:

    #> # A tibble: 6 × 9
    #>   district cluster  team sex     age weight height oedema  muac
    #>   <chr>      <int> <int> <chr> <dbl>  <dbl>  <dbl> <chr>  <int>
    #> 1 Metuge         2     2 m      9.99   10.1   69.3 n        172
    #> 2 Metuge         2     2 f     43.6    10.9   91.5 n        130
    #> 3 Metuge         2     2 f     32.8    11.4   91.4 n        153
    #> 4 Metuge         2     2 f      7.62    8.3   69.5 n        133
    #> 5 Metuge         2     2 m     28.4    10.7   82.3 n        143
    #> 6 Metuge         2     2 f     12.3     6.6   69.4 n        121

Now let’s apply the prevalence function. This data needs to be wrangled
before passing it to the prevalence function:

``` r
anthro.03 |>
  mw_wrangle_wfhz(
    sex = sex,
    .recode_sex = TRUE,
    height = height,
    weight = weight
  ) |>
  mw_estimate_prevalence_wfhz(
    wt = NULL,
    oedema = oedema,
    district
  )
```

The returned output will be:

    #> ================================================================================
    #> # A tibble: 4 × 17
    #>   district   gam_n  gam_p gam_p_low gam_p_upp gam_p_deff sam_n   sam_p sam_p_low
    #>   <chr>      <dbl>  <dbl>     <dbl>     <dbl>      <dbl> <dbl>   <dbl>     <dbl>
    #> 1 Cahora-Ba…    22 0.0738    0.0348    0.113         Inf     1 0.00336  -0.00348
    #> 2 Chiuta        10 0.0444    0.0129    0.0759        Inf     1 0.00444  -0.00466
    #> 3 Maravia       NA 0.0450   NA        NA              NA    NA 0.00351  NA
    #> 4 Metuge        NA 0.0251   NA        NA              NA    NA 0.00155  NA
    #> # ℹ 8 more variables: sam_p_upp <dbl>, sam_p_deff <dbl>, mam_n <dbl>,
    #> #   mam_p <dbl>, mam_p_low <dbl>, mam_p_upp <dbl>, mam_p_deff <dbl>,
    #> #   wt_pop <dbl>

In this output, while in Cahora-Bassa and Chiúta districts all columns
are populated with numbers, in Metuge and Maravia, only the `gam_p`,
`sam_p` and `mam_p` columns are filled with numbers, and everything else
with `NA`. These are the districts wherein the PROBIT method was
applied.

## Estimation of the prevalence of wasting based on MFAZ

The prevalence of wasting based on MFAZ can be estimated using the
[`mw_estimate_prevalence_mfaz()`](https://mphimo.github.io/mwana/dev/reference/mw_estimate_prevalence_mfaz.md)
function. This function is implemented in the same way as demonstrated
in [WFHZ](#sec-prevalence-wfhz), with the exception that its data
wrangling is based on MUAC. This was demonstrated in the [plausibility
checks](https://mphimo.github.io/mwana/articles/plausibility.html).

## Estimation of the prevalence of wasting based on raw MUAC values

This job is assigned to three different functions:
[`mw_estimate_prevalence_muac()`](https://mphimo.github.io/mwana/dev/reference/mw_estimate_prevalence_muac.md),
[`mw_estimate_prevalence_screening()`](https://mphimo.github.io/mwana/dev/reference/muac-screening.md)
and
[`mw_estimate_prevalence_screening2()`](https://mphimo.github.io/mwana/dev/reference/muac-screening.md).
The former is designed for survey data, and the latter two for data
derived from screenings. Nonetheless, under the hood, they all follow
the following logic:

- Before the prevalence estimation begins, they first evaluate the
  acceptability of the standard deviation and of the age ratio tests
  results. Concerning the standard deviation, the former two functions
  evaluation’s are based on MFAZ, whilst the latter function is based on
  the raw MUAC values. As for the age ratio test, the former two
  functions use age in months, and the latter function -
  [`mw_estimate_prevalence_screening2()`](https://mphimo.github.io/mwana/dev/reference/muac-screening.md) -
  is for when age is provided in categorical form (“6-23” and “24-59”
  months).

> **Important**
>
> Although the acceptability is evaluated on the basis of MFAZ where
> applicable, the actual prevalence is estimated on the basis of the raw
> MUAC values. MFAZ is also used to detect outliers and flag them to be
> excluded from the prevalence analysis.

The standard deviation and the age ratio test results are used to
control the prevalence analysis flow in this way:

- If the standard deviation and the age ratio test are both not
  problematic, a normal analysis is performed. This means that, for data
  derived from survey, standard complex sample-based prevalence is
  estimated.
- If the standard deviation is not problematic but the age ratio test is
  problematic, the SMART MUAC tool age-weighting approach is applied in
  either function.

When working with a multiple-area dataset, this logic is applied area
wise.

> **How does it work on a multi-area dataset**
>
> Fundamentally, the function performs the standard deviation and age
> ratio tests, evaluates their acceptability, and returns a summarised
> table by area. It then iterates over that summary table row-by-row
> checking the above conditionals. Based on the conditionals of each row
> (area), the function accesses the original dataframe, pulls out the
> area-specific dataset, then it estimates the prevalence accordingly,
> and binds the results into a summary dataset.

### Estimation for survey data

To demonstrate this we will use the `anthro.04` dataset.

As usual, let’s first inspect it:

    #> # A tibble: 6 × 8
    #>   province   cluster   sex   age  muac oedema   mfaz flag_mfaz
    #>   <chr>        <int> <dbl> <int> <dbl> <chr>   <dbl>     <dbl>
    #> 1 Province 3     743     2    21   130 n      -1.50          0
    #> 2 Province 3     743     2     9   126 n      -1.33          0
    #> 3 Province 3     743     2    12   128 n      -1.27          0
    #> 4 Province 3     743     2    34   145 n      -0.839         0
    #> 5 Province 3     743     2    11   130 n      -1.04          0
    #> 6 Province 3     743     2    33   140 n      -1.23          0

You see that this data has already been wrangled, so we will go straight
to the prevalence estimation.

> **Important**
>
> As in ENA Software, make sure you run the plausibility check before
> you call the prevalence function. This is good to know about the
> acceptability of your data. If we do that with `anthro.04` we will see
> which province has issues, hence what we should expect to see in below
> demonstrations is based on the conditionals stated above.

``` r
anthro.04 |>
  mw_estimate_prevalence_muac(
    wt = NULL,
    oedema = oedema,
    province
  )
```

This will return:

    #> # A tibble: 3 × 17
    #>   province   gam_n  gam_p gam_p_low gam_p_upp gam_p_deff sam_n  sam_p sam_p_low
    #>   <chr>      <dbl>  <dbl>     <dbl>     <dbl>      <dbl> <dbl>  <dbl>     <dbl>
    #> 1 Province 1   133 0.104     0.0778     0.130        Inf    17 0.0133   0.00682
    #> 2 Province 2    NA 0.0858   NA         NA             NA    NA 0.0148  NA
    #> 3 Province 3    87 0.145     0.0930     0.196        Inf    25 0.0416   0.0176
    #> # ℹ 8 more variables: sam_p_upp <dbl>, sam_p_deff <dbl>, mam_n <dbl>,
    #> #   mam_p <dbl>, mam_p_low <dbl>, mam_p_upp <dbl>, mam_p_deff <dbl>,
    #> #   wt_pop <dbl>

We see that in Province 1, all columns are filled with numbers; in
Province 2, some columns are filled with numbers, while other columns
are filled with `NA`s: this is where the age-weighting approach was
applied.

Alternatively, we can choose to apply the function that estimates
age-weighted prevalence inside
[`mw_estimate_prevalence_muac()`](https://mphimo.github.io/mwana/dev/reference/mw_estimate_prevalence_muac.md)
directly onto our dataset. This can be done by calling the
[`mw_estimate_age_weighted_prev_muac()`](https://mphimo.github.io/mwana/dev/reference/mw_estimate_age_weighted_prev_muac.md)
function. It is noteworthy that although possible, it is recommend to
use the main function. This is simply due the fact that if we decide to
use the function independently, then we must, before calling it, check
the acceptability of the standard deviation of MFAZ and of the age ratio
test, and then evaluate if the conditions that fits the use
[`mw_estimate_age_weighted_prev_muac()`](https://mphimo.github.io/mwana/dev/reference/mw_estimate_age_weighted_prev_muac.md)
are there. We would have to do that ourselves. This can be boredom along
the workflow, thereby increase the risk of picking a wrong analysis
workflow.

``` r
anthro.04 |>
  subset(province == "Province 2") |>
  mw_estimate_age_weighted_prev_muac(
    oedema = oedema
  )
```

This returns the prevalence estimates split into age categories and the
overall age-weighted estimate. The latter is given in the last three
columns: `sam`, `mam`, and `gam`.

    #> # A tibble: 1 × 11
    #>   oedema_u2  u2sam u2mam u2gam oedema_o2   o2sam  o2mam  o2gam    sam    mam
    #>       <dbl>  <dbl> <dbl> <dbl>     <dbl>   <dbl>  <dbl>  <dbl>  <dbl>  <dbl>
    #> 1         0 0.0369 0.165 0.202         0 0.00368 0.0239 0.0276 0.0148 0.0710
    #> # ℹ 1 more variable: gam <dbl>

> **Note**
>
> The prevalences that embed the
> [`mw_estimate_age_weighted_prev_muac()`](https://mphimo.github.io/mwana/dev/reference/mw_estimate_age_weighted_prev_muac.md)
> function return that last three columns.

#### Estimation of weighted prevalence

For this we go back `anthro.02` dataset.

We approach this task as follows:

``` r
anthro.02 |>
  mw_wrangle_age(
    age = age,
    .decimals = 2
  ) |>
  mw_wrangle_muac(
    sex = sex,
    .recode_sex = FALSE,
    muac = muac,
    .recode_muac = TRUE,
    .to = "cm",
    age = age
  ) |>
  mutate(
    muac = recode_muac(muac, .to = "mm")
  ) |>
  mw_estimate_prevalence_muac(
    wt = wtfactor,
    oedema = oedema,
    province
  )
```

This will return:

    #> ================================================================================
    #> # A tibble: 2 × 17
    #>   province gam_n  gam_p gam_p_low gam_p_upp gam_p_deff sam_n  sam_p sam_p_low
    #>   <chr>    <dbl>  <dbl>     <dbl>     <dbl>      <dbl> <dbl>  <dbl>     <dbl>
    #> 1 Nampula     61 0.0571    0.0369    0.0773       2.00    19 0.0196   0.00706
    #> 2 Zambezia    57 0.0552    0.0380    0.0725       1.67    10 0.0133   0.00412
    #> # ℹ 8 more variables: sam_p_upp <dbl>, sam_p_deff <dbl>, mam_n <dbl>,
    #> #   mam_p <dbl>, mam_p_low <dbl>, mam_p_upp <dbl>, mam_p_deff <dbl>,
    #> #   wt_pop <dbl>

> **Warning**
>
> You may have noticed that in the above code block, we called the
> [`recode_muac()`](https://mphimo.github.io/mwana/dev/reference/recode_muac.md)
> function inside `mutate()`. This is because after you use
> [`mw_wrangle_muac()`](https://mphimo.github.io/mwana/dev/reference/mw_wrangle_muac.md),
> it puts the MUAC variable in centimetres. The
> [`mw_estimate_prevalence_muac()`](https://mphimo.github.io/mwana/dev/reference/mw_estimate_prevalence_muac.md)
> function was defined to accept MUAC in millimetres; therefore, it must
> be converted to millimetres.

### Estimation for non-survey data

The `anthro.04` dataset will be used to illustrate the application of
these functions.

``` r
anthro.04 |>
  mw_estimate_prevalence_screening(
    muac = muac,
    oedema = oedema,
    province
  )
```

The returned output is:

    #> # A tibble: 3 × 8
    #>   province   gam_n  gam_p sam_n  sam_p mam_n  mam_p     N
    #>   <chr>      <dbl>  <dbl> <dbl>  <dbl> <dbl>  <dbl> <int>
    #> 1 Province 1   133 0.104     17 0.0133   116 0.0908  1277
    #> 2 Province 2    NA 0.0858    NA 0.0148    NA 0.0710    NA
    #> 3 Province 3    87 0.145     25 0.0416    62 0.103    601

The
[`mw_estimate_prevalence_screening2()`](https://mphimo.github.io/mwana/dev/reference/muac-screening.md)
function is applied as demonstrated below. In this example, the input
data contains age in months rather than in categories. To meet the
function’s requirements, we convert the age variable into two categories
and store the result in a new `age_cat` variable.

``` r
anthro.04 |>
  mutate(
    age_cat = ifelse(age < 24, "6-23", "24-59") 
  ) |>
  mw_wrangle_muac(
    sex = sex,
    .recode_sex = FALSE,
    muac = muac
  ) |>
  mw_estimate_prevalence_screening2(
    age_cat = age_cat,
    muac = muac,
    oedema = oedema,
    province
  )
```

This will return:

``` r
anthro.04 |>
  mutate(
    age_cat = ifelse(age < 24, "6-23", "24-59")
  ) |>
  mw_wrangle_muac(
    sex = sex,
    .recode_sex = FALSE,
    muac = muac
  ) |>
  mw_estimate_prevalence_screening2(
    age_cat = age_cat,
    muac = muac,
    oedema = oedema,
    province
  )
```

## Estimation of the combined prevalence of wasting

The estimation of the combined prevalence of wasting is a task
attributed to the
[`mw_estimate_prevalence_combined()`](https://mphimo.github.io/mwana/dev/reference/mw_estimate_prevalence_combined.md)
function. The case-definition is based on the WFHZ, the raw MUAC values
and oedema. From the workflow standpoint, it combines the workflow
demonstrated in [Section 2](#sec-prevalence-wfhz) and in
[Section 4](#sec-prevalence-muac).

To demonstrate it’s implementation we will use the `anthro.01` dataset.

Let’s inspect the data:

    #> # A tibble: 6 × 11
    #>   area      dos        cluster  team sex   dob      age weight height oedema
    #>   <chr>     <date>       <int> <int> <chr> <date> <int>  <dbl>  <dbl> <chr>
    #> 1 District… 2023-12-04       1     3 m     NA        59   15.6  109.  n
    #> 2 District… 2023-12-04       1     3 m     NA         8    7.5   68.6 n
    #> 3 District… 2023-12-04       1     3 m     NA        19    9.7   79.5 n
    #> 4 District… 2023-12-04       1     3 f     NA        49   14.3  100.  n
    #> 5 District… 2023-12-04       1     3 f     NA        32   12.4   92.1 n
    #> 6 District… 2023-12-04       1     3 f     NA        17    9.3   77.8 n
    #> # ℹ 1 more variable: muac <int>

#### Data wrangling

It combines the data wrangling workflow of WFHZ and MUAC:

``` r
## Apply the wrangling workflow ----
anthro.01 |>
  mw_wrangle_age(
    dos = dos,
    dob = dob,
    age = age,
    .decimals = 2
  ) |>
  mw_wrangle_muac(
    sex = sex,
    .recode_sex = TRUE,
    muac = muac,
    .recode_muac = TRUE,
    .to = "cm",
    age = age
  ) |>
  mutate(
    muac = recode_muac(muac, .to = "mm")
  ) |>
  mw_wrangle_wfhz(
    sex = sex,
    weight = weight,
    height = height,
    .recode_sex = FALSE
  )
```

This is to get the `wfhz` and `flag_wfhz` the `mfaz` and `flag_mfaz`
added to the dataset. In the output below, we have just selected these
columns:

    #> ================================================================================
    #> ================================================================================
    #> # A tibble: 1,191 × 5
    #>    area         wfhz flag_wfhz   mfaz flag_mfaz
    #>    <chr>       <dbl>     <dbl>  <dbl>     <dbl>
    #>  1 District E -1.83          0 -1.45          0
    #>  2 District E -0.956         0 -1.67          0
    #>  3 District E -0.796         0 -0.617         0
    #>  4 District E -0.74          0 -1.02          0
    #>  5 District E -0.679         0 -0.93          0
    #>  6 District E -0.432         0 -1.10          0
    #>  7 District E -0.078         0 -0.255         0
    #>  8 District E -0.212         0 -0.677         0
    #>  9 District E -1.07          0 -2.18          0
    #> 10 District E -0.543         0 -0.403         0
    #> # ℹ 1,181 more rows

Under the hood, the function applies the same analysis approach as in
`mw_estimate_prevalence_wfhz` and in
[`mw_estimate_prevalence_muac()`](https://mphimo.github.io/mwana/dev/reference/mw_estimate_prevalence_muac.md).
It checks the acceptability of the standard deviation of WFHZ and MFAZ
and of the age ratio test. The following conditionals are checked and
applied:

- If the standard deviation of WFHZ and of MFAZ, and the age ratio test
  are all concurrently not problematic, the standard complex
  sample-based estimation is applied.
- If any of the above is rated problematic, the prevalence is not
  computed and `NA`s are thrown.

In this function, a concept of “combined flags” is used.

> **What is combined flag?**
>
> Combined flags consists in defining as flag any observation that is
> flagged in either `flag_wfhz` or `flag_mfaz` vectors. A new column
> `cflags` for combined flags is created and added to the dataset. This
> ensures that all flagged observations from both WFHZ and MFAZ data are
> excluded from the prevalence analysis.

| **flag_wfhz** | **flag_mfaz** | **cflags** |
|:-------------:|:-------------:|:----------:|
|       1       |       0       |     1      |
|       0       |       1       |     1      |
|       0       |       0       |     0      |

A glimpse of case-definition of combined flag

Now that we understand what happens under the hood, we can now proceed
to implement it:

``` r
## Apply the workflow ----
anthro.01 |>
  mw_wrangle_age(
    dos = dos,
    dob = dob,
    age = age,
    .decimals = 2
  ) |>
  mw_wrangle_muac(
    sex = sex,
    .recode_sex = TRUE,
    muac = muac,
    .recode_muac = TRUE,
    .to = "cm",
    age = age
  ) |>
  mutate(
    muac = recode_muac(muac, .to = "mm")
  ) |>
  mw_wrangle_wfhz(
    sex = sex,
    weight = weight,
    height = height,
    .recode_sex = FALSE
  ) |>
  mw_estimate_prevalence_combined(
    wt = NULL,
    oedema = oedema,
    area
  )
```

We get this:

    #> ================================================================================
    #> ================================================================================
    #> # A tibble: 2 × 17
    #>   area   cgam_p   csam_p  cmam_p cgam_n cgam_p_low cgam_p_upp cgam_p_deff csam_n
    #>   <chr>   <dbl>    <dbl>   <dbl>  <dbl>      <dbl>      <dbl>       <dbl>  <dbl>
    #> 1 Dist… NA      NA       NA          NA    NA         NA               NA     NA
    #> 2 Dist…  0.0703  0.00747  0.0643     47     0.0447     0.0958         Inf      5
    #> # ℹ 8 more variables: csam_p_low <dbl>, csam_p_upp <dbl>, csam_p_deff <dbl>,
    #> #   cmam_n <dbl>, cmam_p_low <dbl>, cmam_p_upp <dbl>, cmam_p_deff <dbl>,
    #> #   wt_pop <dbl>

In district E `NA`s were returned because there were issues with the
data. I leave it to you to figure out what was/were the issue/issues.

> **Tip**
>
> Consider running the plausibility checkers.
