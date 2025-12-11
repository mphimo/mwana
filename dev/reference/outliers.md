# Identify, flag, and remove outliers

Identify outlier z-scores for weight-for-height (WFHZ) and MUAC-for-age
(MFAZ) following the SMART methodology. The function can also be used to
detect outliers for height-for-age (HFAZ) and weight-for-age (WFAZ)
z-scores following the same approach.

For flagging z-scores, z-scores that deviate substantially from the
sample's z-score mean are considered outliers and are unlikely to
reflect accurate measurements. For raw MUAC, values that are less than
100 millimetres or greater than 200 millimetres are considered outliers
as recommended by Bilukha & Kianian (2023). Including these values in
the analysis could compromise the accuracy of the resulting estimates.

To remove outliers, their values are set to NA rather than removing the
record from the dataset. This process is also called *censoring*. By
assigning NA values to these outliers, they can be effectively removed
during statistical operations with functions that allow for removal of
NA values such as [`mean()`](https://rdrr.io/r/base/mean.html) for
getting the mean value or [`sd()`](https://rdrr.io/r/stats/sd.html) for
getting the standard deviation.

## Usage

``` r
flag_outliers(x, .from = c("zscores", "raw_muac"))

remove_flags(x, .from = c("zscores", "raw_muac"))
```

## Arguments

- x:

  A `numeric` vector of WFHZ, MFAZ, HFAZ, WFAZ or raw MUAC values. Raw
  MUAC values should be in millimetre units.

- .from:

  Either "zscores" or "raw_muac" for type of data to flag outliers from.

## Value

An vector of the same length as `x` of flagged records coded as `1` for
a flagged record and `0` for a non-flagged record.

## References

Bilukha, O., & Kianian, B. (2023). Considerations for assessment of
measurement quality of mid‐upper arm circumference data in
anthropometric surveys and mass nutritional screenings conducted in
humanitarian and refugee settings. *Maternal & Child Nutrition*, 19,
e13478. Available at <https://doi.org/10.1111/mcn.13478>

SMART Initiative (2017). *Standardized Monitoring and Assessment for
Relief and Transition*. Manual 2.0. Available at:
<https://smartmethodology.org>.

## Examples

``` r
## Sample data of raw MUAC values ----
x <- anthro.01$muac

## Apply the function with `.from` set to "raw_muac" ----
m <- flag_outliers(x, .from = "raw_muac")
head(m)
#> [1] 0 0 0 0 0 0

## Sample data of z-scores (be it WFHZ, MFAZ, HFAZ or WFAZ) ----
x <- anthro.02$mfaz

# Apply the function with `.from` set to "zscores" ----
z <- flag_outliers(x, .from = "zscores")
tail(z)
#> [1] 0 0 0 0 0 0

## With `.from` set to "zscores" ----
z <- remove_flags(
  x = wfhz.01$wfhz,
  .from = "zscores"
)

head(z)
#> [1]  1.833  0.278 -0.123  1.442  0.652  0.469

## With `.from` set to "raw_muac" ----
m <- remove_flags(
  x = mfaz.01$muac,
  .from = "raw_muac"
)

tail(m)
#> [1] 146 143 138 153 158 147
```
