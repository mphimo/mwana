# Test for statistical difference between the proportion of children aged 24 to 59 months old over those aged 6 to 23 months old

Calculate the observed age ratio of children aged 24 to 59 months old
over those aged 6 to 23 months old and test if there is a statistically
significant difference between the observed and the expected.

## Usage

``` r
mw_stattest_ageratio(age, .expectedP = 0.66)

mw_stattest_ageratio2(age_cat, .expectedP = 0.66)
```

## Arguments

- age:

  A `numeric` vector of child's age in months.

- .expectedP:

  The expected proportion of children aged 24 to 59 months old over
  those aged 6 to 23 months old. By default, this is expected to be
  0.66.

- age_cat:

  A `character` vector of child's age in categories. Code values should
  be "6-23" and "24-59".

## Value

A `list` object with three elements: `p` for p-value of the difference
between the observed and the expected proportion of children aged 24 to
59 months old over those aged 6 to 23 months old, `observedR` for the
observed ratio, and `observedP` for the observed proportion.

## Details

This function should be used specifically when assessing the quality of
MUAC data. For age ratio test of children aged 6 to 29 months old over
30 to 59 months old, as performed in the SMART plausibility check, use
[`nipnTK::ageRatioTest()`](https://nutriverse.io/nipnTK/reference/ageRatioTest.html)
instead.

## References

SMART Initiative. *Updated MUAC data collection tool*. Available at:
<https://smartmethodology.org/survey-planning-tools/updated-muac-tool/>

## Examples

``` r
mw_stattest_ageratio(
  age = anthro.02$age,
  .expectedP = 0.66
)
#> $p
#> [1] 0.8669039
#> 
#> $observedR
#> [1] 1.955671
#> 
#> $observedP
#> [1] 0.6616674
#> 


age <- ifelse(anthro.02$age < 24, "6-23", "24-59")

mw_stattest_ageratio2(
  age = age,
  .expectedP = 0.66
)
#> $p
#> [1] 0.8669039
#> 
#> $observedR
#> [1] 1.955671
#> 
#> $observedP
#> [1] 0.6616674
#> 
```
