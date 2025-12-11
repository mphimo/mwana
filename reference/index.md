# Package index

## Description

- [`mwana`](https://mphimo.github.io/mwana/reference/mwana-package.md)
  [`mwana-package`](https://mphimo.github.io/mwana/reference/mwana-package.md)
  : mwana: An Efficient Workflow for Plausibility Checks and Prevalence
  Analysis of Wasting in R

## Wrangle data

- [`mw_wrangle_age()`](https://mphimo.github.io/mwana/reference/mw_wrangle_age.md)
  : Wrangle child's age
- [`mw_wrangle_wfhz()`](https://mphimo.github.io/mwana/reference/mw_wrangle_wfhz.md)
  : Wrangle weight-for-height data
- [`mw_wrangle_muac()`](https://mphimo.github.io/mwana/reference/mw_wrangle_muac.md)
  : Wrangle MUAC data

## Statistical tests

- [`mw_stattest_ageratio()`](https://mphimo.github.io/mwana/reference/age_ratio.md)
  [`mw_stattest_ageratio2()`](https://mphimo.github.io/mwana/reference/age_ratio.md)
  : Test for statistical difference between the proportion of children
  aged 24 to 59 months old over those aged 6 to 23 months old

## IPC sample size checks

- [`mw_check_ipcamn_ssreq()`](https://mphimo.github.io/mwana/reference/mw_check_ipcamn_ssreq.md)
  : Check whether sample size requirements for IPC Acute Malnutrition
  (IPC AMN) analysis are met

## Plausibility checks

- [`mw_plausibility_check_wfhz()`](https://mphimo.github.io/mwana/reference/mw_plausibility_check_wfhz.md)
  : Check the plausibility and acceptability of weight-for-height
  z-score (WFHZ) data
- [`mw_plausibility_check_mfaz()`](https://mphimo.github.io/mwana/reference/mw_plausibility_check_mfaz.md)
  : Check the plausibility and acceptability of MUAC-for-age z-score
  (MFAZ) data
- [`mw_plausibility_check_muac()`](https://mphimo.github.io/mwana/reference/mw_plausibility_check_muac.md)
  : Check the plausibility and acceptability of raw MUAC data

## Neat output tables

- [`mw_neat_output_wfhz()`](https://mphimo.github.io/mwana/reference/mw_neat_output_wfhz.md)
  : Clean and format the output tibble returned from the WFHZ
  plausibility check
- [`mw_neat_output_mfaz()`](https://mphimo.github.io/mwana/reference/mw_neat_output_mfaz.md)
  : Clean and format the output tibble returned from the MUAC-for-age
  z-score plausibility check
- [`mw_neat_output_muac()`](https://mphimo.github.io/mwana/reference/mw_neat_output_muac.md)
  : Clean and format the output tibble returned from the MUAC
  plausibility check

## Prevalence estimators

- [`mw_estimate_prevalence_wfhz()`](https://mphimo.github.io/mwana/reference/mw_estimate_prevalence_wfhz.md)
  : Estimate the prevalence of wasting based on weight-for-height
  z-scores (WFHZ)
- [`mw_estimate_prevalence_muac()`](https://mphimo.github.io/mwana/reference/mw_estimate_prevalence_muac.md)
  : Estimate the prevalence of wasting based on MUAC for survey data
- [`mw_estimate_prevalence_mfaz()`](https://mphimo.github.io/mwana/reference/mw_estimate_prevalence_mfaz.md)
  : Estimate the prevalence of wasting based on z-scores of muac-for-age
  (MFAZ)
- [`mw_estimate_prevalence_combined()`](https://mphimo.github.io/mwana/reference/mw_estimate_prevalence_combined.md)
  : Estimate the prevalence of combined wasting
- [`mw_estimate_prevalence_screening()`](https://mphimo.github.io/mwana/reference/muac-screening.md)
  [`mw_estimate_prevalence_screening2()`](https://mphimo.github.io/mwana/reference/muac-screening.md)
  : Estimate the prevalence of wasting based on MUAC for non-survey data
- [`mw_estimate_age_weighted_prev_muac()`](https://mphimo.github.io/mwana/reference/mw_estimate_age_weighted_prev_muac.md)
  : Estimate age-weighted prevalence of wasting by MUAC

## Utilities

- [`get_age_months()`](https://mphimo.github.io/mwana/reference/get_age_months.md)
  : Calculate child's age in months
- [`recode_muac()`](https://mphimo.github.io/mwana/reference/recode_muac.md)
  : Convert MUAC values to either centimetres or millimetres
- [`flag_outliers()`](https://mphimo.github.io/mwana/reference/outliers.md)
  [`remove_flags()`](https://mphimo.github.io/mwana/reference/outliers.md)
  : Identify, flag, and remove outliers
- [`define_wasting()`](https://mphimo.github.io/mwana/reference/define_wasting.md)
  : Define wasting

## Datasets

- [`anthro.01`](https://mphimo.github.io/mwana/reference/anthro.01.md) :
  A sample data of district level SMART surveys with location anonymised
- [`anthro.02`](https://mphimo.github.io/mwana/reference/anthro.02.md) :
  A sample of an already wrangled survey data
- [`anthro.03`](https://mphimo.github.io/mwana/reference/anthro.03.md) :
  A sample data of district level SMART surveys conducted in Mozambique
- [`anthro.04`](https://mphimo.github.io/mwana/reference/anthro.04.md) :
  A sample data from a community-based sentinel site in an anonymized
  location
- [`mfaz.01`](https://mphimo.github.io/mwana/reference/mfaz.01.md) : A
  sample mid-upper arm circumference (MUAC) screening data
- [`mfaz.02`](https://mphimo.github.io/mwana/reference/mfaz.02.md) : A
  sample SMART survey data with mid-upper arm circumference measurements
- [`wfhz.01`](https://mphimo.github.io/mwana/reference/wfhz.01.md) : A
  sample SMART survey data with weight-for-height z-score standard
  deviation rated as problematic
