# Score the acceptability rating of the check results that constitutes the plausibility check suite

Attribute a score, also known as *penalty point*, for a given rate of
acceptability of the standard deviation, proportion of flagged records,
age and sex ratio, skewness, kurtosis and digit preference score check
results. The scoring criteria and thresholds follows the standards in
the SMART plausibility check.

## Usage

``` r
score_std_flags(x)

score_agesexr_dps(x)

score_skewkurt(x)
```

## Arguments

- x:

  A `character` vector of the acceptability rate of a given check. '

## Value

An `integer` vector with the same length as `x` of the acceptability
score.

## References

SMART Initiative (2017). *Standardized Monitoring and Assessment for
Relief and Transition*. Manual 2.0. Available at:
<https://smartmethodology.org>.
