# Running plausibility checks

## Introduction

Plausibility check is a tool that evaluates the overall quality and
acceptability of anthropometric data to ensure its suitability for
informing decision-making process.

`mwana` provides a set of handy functions to facilitate this evaluation.
These functions allow users to assess the acceptability of
weight-for-height z-score (WFHZ) and mid upper-arm circumference (MUAC)
data. The evaluation of the latter can be done on the basis of
MUAC-for-age z-score (MFAZ) or raw MUAC values.

In this vignette, we will learn how to use these functions and when to
consider using MFAZ plausibility check over the one based on raw MUAC
values. For demonstration, we will use a `mwana` built-in sample dataset
named `anthro.01`. This dataset contains district level SMART surveys
from anonymised locations. Do
[`?anthro.01`](https://mphimo.github.io/mwana/reference/anthro.01.md) in
`R` console to read more about it.

We will begin the demonstration with the plausibility check that you are
most familiar with and then proceed to the ones you are less familiar
with.

### Plausibility check of WFHZ data

We check the plausibility of WFHZ data by calling the
[`mw_plausibility_check_wfhz()`](https://mphimo.github.io/mwana/reference/mw_plausibility_check_wfhz.md)
function. Before doing that, we need ensure the data is in the right
“shape and format” that is accepted and understood by the function.
Don’t worry, you will soon learn how to get there. But first, let’s take
a moment to walk you through some key features about this function.

[`mw_plausibility_check_wfhz()`](https://mphimo.github.io/mwana/reference/mw_plausibility_check_wfhz.md)
is a replica of the plausibility check in ENA for SMART software of the
SMART Methodology ([SMART Initiative, 2017](#ref-smart2017)). Under the
hood, it runs the same test suite you already know from SMART. It also
applies the same rating and scoring criteria. Beware though that there
are some small differences to have in mind:

1.  [`mw_plausibility_check_wfhz()`](https://mphimo.github.io/mwana/reference/mw_plausibility_check_wfhz.md)
    does not include MUAC in its test suite. This is simply due the fact
    that now you can run a more comprehensive test suite for MUAC.

2.  [`mw_plausibility_check_wfhz()`](https://mphimo.github.io/mwana/reference/mw_plausibility_check_wfhz.md)
    allows user to run checks on a multiple-area dataset at once,
    without having to repeat the same workflow over and over again for
    the number of areas the data holds.

That is it! Now we can begin delving into the “how to”.

It is always a good practice to start off by inspecting our dataset.
Let’s check the first 6 rows of our dataset:

``` r
head(anthro.01)
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
```

We can see that the dataset has eleven variables, and the way how their
respective values are presented. This is useful to inform the data
wrangling workflow.

#### Data wrangling

As mentioned somewhere above, before we supply a data object to
[`mw_plausibility_check_wfhz()`](https://mphimo.github.io/mwana/reference/mw_plausibility_check_wfhz.md),
we need to wrangle it first. This task is executed by
[`mw_wrangle_age()`](https://mphimo.github.io/mwana/reference/mw_wrangle_age.md)
and
[`mw_wrangle_wfhz()`](https://mphimo.github.io/mwana/reference/mw_wrangle_wfhz.md).
Read more about the technical documentation by doing
[`help("mw_wrangle_age")`](https://mphimo.github.io/mwana/reference/mw_wrangle_age.md)
or
[`help("mw_wrangle_wfhz")`](https://mphimo.github.io/mwana/reference/mw_wrangle_wfhz.md)
in `R` console.

##### Wrangling age

We use
[`mw_wrangle_age()`](https://mphimo.github.io/mwana/reference/mw_wrangle_age.md)
to calculate child’s age in months based on the date of data collection
and child’s date of birth. This is done as follows:

``` r
1age_mo <- mw_wrangle_age(
2  df = anthro.01
3  dos = dos,
4  dob = dob,
5  age = age,
6  .decimals = 2
)
```

- 1:

  The output for this operation will be assigned to an object called
  `age_mo`.

- 2:

  The argument `df` is supplied with the `anthro.01` object which
  contains variables related to age that will be used for the wrangling
  process.

- 3:

  The argument `dos` is supplied with the unquoted variable name in `df`
  that contains the date when the data collection was performed. In the
  `anthro.01` dataset, this so happens to be `dos` as well.

- 4:

  The argument `dob` is supplied with the unquoted variable name in `df`
  that contains the date when the child was born. In the `anthro.01`
  dataset, this so happens to be `dob` as well.

- 5:

  The argument `age` is supplied with the unquoted variable name in `df`
  that contains the age of the child in months. In the `anthro.01`
  dataset, this so happens to be `age` as well.

- 6:

  The argument `.decimals` allows the user to specify the number of
  decimal places to which the output age values will be rounded off to.
  By default, `.decimals` is set to 2. So, even without specifying this
  argument, the resulting output will be rounded off to 2.

This will return:

    #> # A tibble: 6 × 12
    #>   area      dos        cluster  team sex   dob      age weight height oedema
    #>   <chr>     <date>       <int> <int> <chr> <date> <int>  <dbl>  <dbl> <chr>
    #> 1 District… 2023-12-04       1     3 m     NA        59   15.6  109.  n
    #> 2 District… 2023-12-04       1     3 m     NA         8    7.5   68.6 n
    #> 3 District… 2023-12-04       1     3 m     NA        19    9.7   79.5 n
    #> 4 District… 2023-12-04       1     3 f     NA        49   14.3  100.  n
    #> 5 District… 2023-12-04       1     3 f     NA        32   12.4   92.1 n
    #> 6 District… 2023-12-04       1     3 f     NA        17    9.3   77.8 n
    #> # ℹ 2 more variables: muac <int>, age_days <dbl>

##### Wrangling all other remaining variables

For this, we call
[`mw_wrangle_wfhz()`](https://mphimo.github.io/mwana/reference/mw_wrangle_wfhz.md)
as follows:

``` r
wrangled_df <- anthro.01 |>
  mw_wrangle_wfhz(
    sex = sex,
    weight = weight,
    height = height,
    .recode_sex = TRUE
  )
```

In this example, the argument `.recode_sex` was set to `TRUE`. That is
because under the hood, to compute the z-scores, a task made possible
thanks to the {`zscorer`} package ([Myatt and Guevarra,
2019](#ref-zscorer)), it uses sex coded into 1 and 2 for male and
female, respectively. This means that if our sex variable is already in
1 and 2’s, we would set it to `FALSE`.

> **Note**
>
> If by any chance your sex variable is coded in any other different way
> than aforementioned, then you will have to recode it outside `mwana`
> utilities and then set `.recode_sex` accordingly.

Under the hood, after recoding (or not) the sex variables,
[`mw_wrangle_wfhz()`](https://mphimo.github.io/mwana/reference/mw_wrangle_wfhz.md)
computes the z-scores, then identifies outliers and adds them to the
dataset. Two new variables (`wfhz` and `flag_wfhz`) are created and
added to the dataset. We can see this below:

    #> ================================================================================
    #> # A tibble: 6 × 3
    #>   area         wfhz flag_wfhz
    #>   <chr>       <dbl>     <dbl>
    #> 1 District E -1.83          0
    #> 2 District E -0.956         0
    #> 3 District E -0.796         0
    #> 4 District E -0.74          0
    #> 5 District E -0.679         0
    #> 6 District E -0.432         0

#### On to *de facto* plausibility check of WFHZ data

We can check the plausibility of our data by calling
[`mw_plausibility_check_wfhz()`](https://mphimo.github.io/mwana/reference/mw_plausibility_check_wfhz.md)
function as demonstrated below:

``` r
x <- wrangled_df |>
  mw_plausibility_check_wfhz(
    sex = sex,
    age = age,
    weight = weight,
    height = height,
    flags = flag_wfhz
  )
```

Or we can chain all previous functions in this way:

``` r
x <- anthro.01 |>
  mw_wrangle_age(
    dos = dos,
    dob = dob,
    age = age,
    .decimals = 2
  ) |>
  mw_wrangle_wfhz(
    sex = sex,
    weight = weight,
    height = height,
    .recode_sex = TRUE
  ) |>
  mw_plausibility_check_wfhz(
    sex = sex,
    age = age,
    weight = weight,
    height = height,
    flags = flag_wfhz
  )
```

The returned output is:

    #> ================================================================================
    #> # A tibble: 1 × 19
    #>       n flagged flagged_class sex_ratio sex_ratio_class age_ratio
    #>   <int>   <dbl> <fct>             <dbl> <chr>               <dbl>
    #> 1  1191  0.0101 Excellent         0.297 Excellent           0.409
    #> # ℹ 13 more variables: age_ratio_class <chr>, dps_wgt <dbl>,
    #> #   dps_wgt_class <chr>, dps_hgt <dbl>, dps_hgt_class <chr>, sd <dbl>,
    #> #   sd_class <chr>, skew <dbl>, skew_class <fct>, kurt <dbl>, kurt_class <fct>,
    #> #   quality_score <dbl>, quality_class <fct>

As we can see, the returned output is a summary table of statistics and
ratings. We can neat it for more clarity and readability. We can achieve
this by chaining
[`mw_neat_output_wfhz()`](https://mphimo.github.io/mwana/reference/mw_neat_output_wfhz.md)
to the previous pipeline:

``` r
anthro.01 |>
  mw_wrangle_age(
    dos = dos,
    dob = dob,
    age = age,
    .decimals = 2
  ) |>
  mw_wrangle_wfhz(
    sex = sex,
    weight = weight,
    height = height,
    .recode_sex = TRUE
  ) |>
  mw_plausibility_check_wfhz(
    sex = sex,
    age = age,
    weight = weight,
    height = height,
    flags = flag_wfhz
  ) |>
  mw_neat_output_wfhz()
```

This will give us:

    #> ================================================================================
    #> # A tibble: 1 × 19
    #>   `Total children` `Flagged data (%)` `Class. of flagged data` `Sex ratio (p)`
    #>              <int> <chr>              <fct>                    <chr>
    #> 1             1191 1.0%               Excellent                0.297
    #> # ℹ 15 more variables: `Class. of sex ratio` <chr>, `Age ratio (p)` <chr>,
    #> #   `Class. of age ratio` <chr>, `DPS weight (#)` <dbl>,
    #> #   `Class. DPS weight` <chr>, `DPS height (#)` <dbl>,
    #> #   `Class. DPS height` <chr>, `Standard Dev* (#)` <dbl>,
    #> #   `Class. of standard dev` <chr>, `Skewness* (#)` <dbl>,
    #> #   `Class. of skewness` <fct>, `Kurtosis* (#)` <dbl>,
    #> #   `Class. of kurtosis` <fct>, `Overall score` <dbl>, …

An already formatted table, with scientific notations converted to
standard notations, etc.

When working on a multiple-area dataset, for instance districts, we can
check the plausibility of all districts in the dataset at once by
specifying a vector (or a list of vectors) to the function as follows:

``` r
anthro.01 |>
  mw_wrangle_age(
    dos = dos,
    dob = dob,
    age = age,
    .decimals = 2
  ) |>
  mw_wrangle_wfhz(
    sex = sex,
    weight = weight,
    height = height,
    .recode_sex = TRUE
  ) |>
  mw_plausibility_check_wfhz(
    sex = sex,
    age = age,
    weight = weight,
    height = height,
    flags = flag_wfhz, 
1    area, team
  ) |> 
  mw_neat_output_wfhz()
```

- 1:

  List of vectors specified for which the analysis should be summarised.
  In this case, the analysis will be summarised at each survey team in
  `District E` and `District G`.

This will return the following:

    #> ================================================================================
    #> # A tibble: 8 × 21
    #> # Groups:   Area, Team [8]
    #>   Area        Team `Total children` `Flagged data (%)` `Class. of flagged data`
    #>   <chr>      <int>            <int> <chr>              <fct>
    #> 1 District E     1              120 0.0%               Excellent
    #> 2 District E     2              216 1.4%               Excellent
    #> 3 District E     3              104 0.0%               Excellent
    #> 4 District E     4               65 1.5%               Excellent
    #> 5 District G     1              200 0.0%               Excellent
    #> 6 District G     6              140 1.4%               Excellent
    #> 7 District G     7              188 1.6%               Excellent
    #> 8 District G    10              158 1.9%               Excellent
    #> # ℹ 16 more variables: `Sex ratio (p)` <chr>, `Class. of sex ratio` <chr>,
    #> #   `Age ratio (p)` <chr>, `Class. of age ratio` <chr>, `DPS weight (#)` <dbl>,
    #> #   `Class. DPS weight` <chr>, `DPS height (#)` <dbl>,
    #> #   `Class. DPS height` <chr>, `Standard Dev* (#)` <dbl>,
    #> #   `Class. of standard dev` <chr>, `Skewness* (#)` <dbl>,
    #> #   `Class. of skewness` <fct>, `Kurtosis* (#)` <dbl>,
    #> #   `Class. of kurtosis` <fct>, `Overall score` <dbl>, …

At this point, you have reached the end of your workflow 🎉 .

### Plausibility check of MFAZ data

We will assess the plausibility of MUAC data through MFAZ if we have age
variable available in our dataset.

> **Note**
>
> The plausibility check for MFAZ data was built based on the insights
> gotten from Bilukha and Kianian ([2023](#ref-bilukha)) research
> presented at the 2023 High-Level Technical Assessment Workshop held in
> Nairobi, Kenya ([SMART Initiative, 2023](#ref-smarthighlevel)).
> Results from this research suggested a feasibility of applying the
> similar plausibility check as that of WFHZ for MFAZ, with a maximum
> acceptability of percent of flagged records of 2.0%.

We can run MFAZ plausibility check by calling
[`mw_plausibility_check_mfaz()`](https://mphimo.github.io/mwana/reference/mw_plausibility_check_mfaz.md).
As in WFHZ, we first need to ensure that the data is in the right shape
and format that is accepted and understood by the function. The workflow
starts with wrangling age; for this, we approach the same way as in
[Section 1.1.1.1](#sec-age).

> **Age ratio test in MFAZ**
>
> As you know, the age ratio test in WFHZ is done on children aged 6 to
> 29 months old over those aged 30 to 59 months old. This is different
> in MFAZ. The test is done on children aged 6 to 23 months over those
> aged 24 to 59 months old. This is as in the SMART MUAC Tool ([SMART
> Initiative, n.d.](#ref-smartmuactool)). The test results is also used
> in the prevalence analysis to implement what the SMART MUAC tool does.
> This is further demonstrated in the vignette about prevalence.

#### Wrangling MFAZ data

This is the job of
[`mw_wrangle_muac()`](https://mphimo.github.io/mwana/reference/mw_wrangle_muac.md)
function. We use it as follows:

``` r
anthro.01 |>
  mw_wrangle_age(
    dos = dos,
    dob = dob,
    age = age,
    .decimals = 2
  ) |>
  mw_wrangle_muac(
    sex = sex,
    muac = muac,
    age = age,
    .recode_sex = TRUE,
    .recode_muac = TRUE,
    .to = "cm"
  )
```

Just as in WFHZ wrangler, under the hood,
[`mw_wrangle_muac()`](https://mphimo.github.io/mwana/reference/mw_wrangle_muac.md)
computes the z-scores then identifies outliers and flags them. These are
stored in the `mfaz` and `flag_mfaz` variables that are created and
added to the dataset.

The above code returns:

    #> ================================================================================
    #> # A tibble: 1,191 × 14
    #>    area     dos        cluster  team   sex dob      age weight height oedema
    #>    <chr>    <date>       <int> <int> <dbl> <date> <int>  <dbl>  <dbl> <chr>
    #>  1 Distric… 2023-12-04       1     3     1 NA        59   15.6  109.  n
    #>  2 Distric… 2023-12-04       1     3     1 NA         8    7.5   68.6 n
    #>  3 Distric… 2023-12-04       1     3     1 NA        19    9.7   79.5 n
    #>  4 Distric… 2023-12-04       1     3     2 NA        49   14.3  100.  n
    #>  5 Distric… 2023-12-04       1     3     2 NA        32   12.4   92.1 n
    #>  6 Distric… 2023-12-04       1     3     2 NA        17    9.3   77.8 n
    #>  7 Distric… 2023-12-04       1     3     2 NA        20   10.1   80.4 n
    #>  8 Distric… 2023-12-04       1     3     2 NA        27   11.7   87.1 n
    #>  9 Distric… 2023-12-04       1     3     1 NA        46   13.6   98   n
    #> 10 Distric… 2023-12-04       1     3     1 NA        58   17.2  109.  n
    #> # ℹ 1,181 more rows
    #> # ℹ 4 more variables: muac <dbl>, age_days <dbl>, mfaz <dbl>, flag_mfaz <dbl>

> **Note**
>
> [`mw_wrangle_muac()`](https://mphimo.github.io/mwana/reference/mw_wrangle_muac.md)
> accepts MUAC values in centimetres. This is why it takes the arguments
> `.recode_muac` and `.to` to control whether there is need to transform
> the variable `muac` or not. Read the function documentation to learn
> about how to control these two arguments.

#### On to *de facto* plausibility check of MFAZ data

We achieve this by calling the
[`mw_plausibility_check_mfaz()`](https://mphimo.github.io/mwana/reference/mw_plausibility_check_mfaz.md)
function:

``` r
anthro.01 |>
  mw_wrangle_age(
    dos = dos,
    dob = dob,
    age = age,
    .decimals = 2
  ) |>
  mw_wrangle_muac(
    sex = sex,
    muac = muac,
    age = age,
    .recode_sex = TRUE,
    .recode_muac = TRUE,
    .to = "cm"
  ) |>
  mw_plausibility_check_mfaz(
    sex = sex,
    muac = muac,
    age = age,
    flags = flag_mfaz
  )
```

And this will return:

    #> ================================================================================
    #> # A tibble: 1 × 17
    #>       n flagged flagged_class sex_ratio sex_ratio_class age_ratio
    #>   <int>   <dbl> <fct>             <dbl> <chr>               <dbl>
    #> 1  1191 0.00504 Excellent         0.297 Excellent           0.636
    #> # ℹ 11 more variables: age_ratio_class <chr>, dps <dbl>, dps_class <chr>,
    #> #   sd <dbl>, sd_class <chr>, skew <dbl>, skew_class <fct>, kurt <dbl>,
    #> #   kurt_class <fct>, quality_score <dbl>, quality_class <fct>

We can also neat this output. We just need to call
[`mw_neat_output_mfaz()`](https://mphimo.github.io/mwana/reference/mw_neat_output_mfaz.md)
and chain it to the pipeline:

``` r
anthro.01 |>
  mw_wrangle_age(
    dos = dos,
    dob = dob,
    age = age,
    .decimals = 2
  ) |>
  mw_wrangle_muac(
    sex = sex,
    muac = muac,
    age = age,
    .recode_sex = TRUE,
    .recode_muac = TRUE,
    .to = "cm"
  ) |>
  mw_plausibility_check_mfaz(
    sex = sex,
    muac = muac,
    age = age,
    flags = flag_mfaz
  ) |>
  mw_neat_output_mfaz()
```

This will return:

    #> ================================================================================
    #> # A tibble: 1 × 17
    #>   `Total children` `Flagged data (%)` `Class. of flagged data` `Sex ratio (p)`
    #>              <int> <chr>              <fct>                    <chr>
    #> 1             1191 0.5%               Excellent                0.297
    #> # ℹ 13 more variables: `Class. of sex ratio` <chr>, `Age ratio (p)` <chr>,
    #> #   `Class. of age ratio` <chr>, `DPS (#)` <dbl>, `Class. of DPS` <chr>,
    #> #   `Standard Dev* (#)` <dbl>, `Class. of standard dev` <chr>,
    #> #   `Skewness* (#)` <dbl>, `Class. of skewness` <fct>, `Kurtosis* (#)` <dbl>,
    #> #   `Class. of kurtosis` <fct>, `Overall score` <dbl>, `Overall quality` <fct>

We can also run checks on a multiple-area dataset as follows:

``` r
anthro.01 |>
  mw_wrangle_age(
    dos = dos,
    dob = dob,
    age = age,
    .decimals = 2
  ) |>
  mw_wrangle_muac(
    sex = sex,
    muac = muac,
    age = age,
    .recode_sex = TRUE,
    .recode_muac = TRUE,
    .to = "cm"
  ) |>
  mw_plausibility_check_mfaz(
    sex = sex,
    muac = muac,
    age = age,
    flags = flag_mfaz,
    area
  ) |>
  mw_neat_output_mfaz()
```

This will return:

    #> ================================================================================
    #> # A tibble: 2 × 18
    #> # Groups:   Area [2]
    #>   Area       `Total children` `Flagged data (%)` `Class. of flagged data`
    #>   <chr>                 <int> <chr>              <fct>
    #> 1 District E              505 0.0%               Excellent
    #> 2 District G              686 0.9%               Excellent
    #> # ℹ 14 more variables: `Sex ratio (p)` <chr>, `Class. of sex ratio` <chr>,
    #> #   `Age ratio (p)` <chr>, `Class. of age ratio` <chr>, `DPS (#)` <dbl>,
    #> #   `Class. of DPS` <chr>, `Standard Dev* (#)` <dbl>,
    #> #   `Class. of standard dev` <chr>, `Skewness* (#)` <dbl>,
    #> #   `Class. of skewness` <fct>, `Kurtosis* (#)` <dbl>,
    #> #   `Class. of kurtosis` <fct>, `Overall score` <dbl>, `Overall quality` <fct>

At this point, you have reached the end of your workflow ✨.

### Plausibility check of raw MUAC data

We will assess the plausibility of raw MUAC data through it’s raw values
when the variable age is not available in the dataset. This is a job
assigned to
[`mw_plausibility_check_muac()`](https://mphimo.github.io/mwana/reference/mw_plausibility_check_muac.md).
The workflow for this check is the shortest one.

#### Data wrangling

As you can tell, z-scores cannot be computed in the absence of age. In
this way, the data wrangling workflow would be quite minimal. You still
set the arguments inside
[`mw_wrangle_muac()`](https://mphimo.github.io/mwana/reference/mw_wrangle_muac.md)
as learned in [Section 1.2.1](#sec-wrangle_mfaz). The only difference is
that here we will set `age` to `NULL`. Fundamentally, under the hood the
function detects MUAC values that are outliers and flags them and stores
them in `flag_muac` variable that is added to the dataset.

We will continue using the same dataset:

``` r
anthro.01 |>
  mw_wrangle_muac(
    sex = sex,
    muac = muac,
    age = NULL,
    .recode_sex = TRUE,
    .recode_muac = FALSE,
    .to = "none"
  )
```

This returns:

    #> # A tibble: 1,191 × 12
    #>    area     dos        cluster  team   sex dob      age weight height oedema
    #>    <chr>    <date>       <int> <int> <dbl> <date> <int>  <dbl>  <dbl> <chr>
    #>  1 Distric… 2023-12-04       1     3     1 NA        59   15.6  109.  n
    #>  2 Distric… 2023-12-04       1     3     1 NA         8    7.5   68.6 n
    #>  3 Distric… 2023-12-04       1     3     1 NA        19    9.7   79.5 n
    #>  4 Distric… 2023-12-04       1     3     2 NA        49   14.3  100.  n
    #>  5 Distric… 2023-12-04       1     3     2 NA        32   12.4   92.1 n
    #>  6 Distric… 2023-12-04       1     3     2 NA        17    9.3   77.8 n
    #>  7 Distric… 2023-12-04       1     3     2 NA        20   10.1   80.4 n
    #>  8 Distric… 2023-12-04       1     3     2 NA        27   11.7   87.1 n
    #>  9 Distric… 2023-12-04       1     3     1 NA        46   13.6   98   n
    #> 10 Distric… 2023-12-04       1     3     1 NA        58   17.2  109.  n
    #> # ℹ 1,181 more rows
    #> # ℹ 2 more variables: muac <int>, flag_muac <dbl>

#### On to *de facto* plausibility check

We just have to add
[`mw_plausibility_check_muac()`](https://mphimo.github.io/mwana/reference/mw_plausibility_check_muac.md)
to the above pipeline:

``` r
anthro.01 |>
  mw_wrangle_muac(
    sex = sex,
    muac = muac,
    age = NULL,
    .recode_sex = TRUE,
    .recode_muac = FALSE,
    .to = "none"
  ) |>
  mw_plausibility_check_muac(
    sex = sex,
    flags = flag_muac,
    muac = muac
  )
```

And this will return:

    #> # A tibble: 1 × 9
    #>       n flagged flagged_class sex_ratio sex_ratio_class   dps dps_class    sd
    #>   <int>   <dbl> <fct>             <dbl> <chr>           <dbl> <chr>     <dbl>
    #> 1  1191 0.00252 Excellent         0.297 Excellent        5.39 Excellent  11.1
    #> # ℹ 1 more variable: sd_class <fct>

We can also return a formatted table with
[`mw_neat_output_muac()`](https://mphimo.github.io/mwana/reference/mw_neat_output_muac.md):

``` r
anthro.01 |>
  mw_wrangle_muac(
    sex = sex,
    muac = muac,
    age = NULL,
    .recode_sex = TRUE,
    .recode_muac = FALSE,
    .to = "none"
  ) |>
  mw_plausibility_check_muac(
    sex = sex,
    flags = flag_muac,
    muac = muac
  ) |>
  mw_neat_output_muac()
```

And we get:

    #> # A tibble: 1 × 9
    #>   `Total children` `Flagged data (%)` `Class. of flagged data` `Sex ratio (p)`
    #>              <int> <chr>              <fct>                    <chr>
    #> 1             1191 0.3%               Excellent                0.297
    #> # ℹ 5 more variables: `Class. of sex ratio` <chr>, `DPS(#)` <dbl>,
    #> #   `Class. of DPS` <chr>, `Standard Dev* (#)` <dbl>,
    #> #   `Class. of standard dev` <fct>

When working on multiple-area data, we approach the task the same way as
demonstrated above:

``` r
## Check plausibility ----
anthro.01 |>
  mw_wrangle_muac(
    sex = sex,
    muac = muac,
    age = NULL,
    .recode_sex = TRUE,
    .recode_muac = FALSE,
    .to = "none"
  ) |>
  mw_plausibility_check_muac(
    sex = sex,
    flags = flag_muac,
    muac = muac, 
    area
  ) |>
  mw_neat_output_muac()
```

And we get:

    #> # A tibble: 2 × 10
    #> # Groups:   Area [2]
    #>   Area       `Total children` `Flagged data (%)` `Class. of flagged data`
    #>   <chr>                 <int> <chr>              <fct>
    #> 1 District E              505 0.0%               Excellent
    #> 2 District G              686 0.4%               Excellent
    #> # ℹ 6 more variables: `Sex ratio (p)` <chr>, `Class. of sex ratio` <chr>,
    #> #   `DPS(#)` <dbl>, `Class. of DPS` <chr>, `Standard Dev* (#)` <dbl>,
    #> #   `Class. of standard dev` <fct>

## References

Bilukha, O. and Kianian, B. (2023) ‘Considerations for assessment of
measurement quality of mid-upper arm circumference data in
anthropometric surveys and mass nutritional screenings conducted in
humanitarian and refugee settings’, *Maternal & Child Nutrition*, 19, p.
e13478. doi:[10.1111/mcn.13478](https://doi.org/10.1111/mcn.13478).

Myatt, M. and Guevarra, E. (2019) *Zscorer: Child anthropometry z-score
calculator*. Available at: <https://CRAN.R-project.org/package=zscorer>.

SMART Initiative (2017) *Standardized monitoring and assessment for
relief and transition*. Action Against Hunger Canada. Available at:
<https://smartmethodology.org>.

SMART Initiative (2023) *2023 high-level technical assessment workshop
report*. Available at:
<https://smartmethodology.org/wp-content/uploads/2024/03/2023-High-level-Technical-Assessment-Workshop-Report.pdf>.

SMART Initiative (n.d.) ‘Updated SMART MUAC tool’. Available at:
<https://smartmethodology.org/survey-planning-tools/updated-muac-tool/>.
