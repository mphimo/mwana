# mwana: An efficient workflow for plausibility checks and prevalence analysis of wasting in R

Child anthropometric assessments are central to child nutrition and
food-security surveillance worldwide. Ensuring the quality of these data
is essential for accurate estimates of child undernutrition prevalence.
Timely reporting is also critical for situation analysis and for
mounting effective responses.

The `mwana` package streamlines data-quality checks and
acute-undernutrition prevalence estimation from anthropometric data for
children aged 6–59 months. It builds on methods and guidance from the
[Standardized Monitoring and Assessment of Relief and Transitions
(SMART) initiative](https://smartmethodology.org) and provides
convenient wrappers around functions in the
[`nipnTK`](https://nutriverse.io/nipnTK) package.

The term ***mwana*** means child in *Elómwè*, a local language spoken in
the central-northern regions of Mozambique where the author hails from.
It also has a similar meaning across other Bantu languages, such as
*Swahili*, spoken in many parts of Africa.

## Motivation

The standard child-anthropometry appraisal workflow is complex and
time-consuming, relying on multiple tools—such as SPSS, Microsoft Excel,
and SMART ENA software—for various steps of the process. Each dataset
requires the repetition of these steps—often under tight deadlines,
which makes the manual and repetitive workflow highly error-prone.

`mwana` provides functions that simplify this cumbersome workflow,
enabling it to be programmatically designed, particularly when handling
multi-area datasets.

## Installation

`mwana` is not yet on CRAN but can be installed from GitHub:

``` r
# First install remotes package with: install.package("remotes")
# Then install mwana package from GitHub with: 
remotes::install_github(repo = "mphimo/mwana", dependencies = TRUE)
```

## What does `mwana` do?

> \[!NOTE\]
>
> `mwana` is experimental and currently in late-stage alpha testing,
> approaching a stable release. Future changes are expected to be
> backward-compatible (patch or minor releases), but some functionality
> may still change.

![](reference/figures/workflow.png)Currently, `mwana` has the following
functionalities that support the creation of a programmatic workflow
illustrated in the figure to the left.

### 1. Data plausibility checks of acute undernutrition anthropometric data of children 6-59 months old

`mwana` provides functions to perform data plausibility checks on
weight-for-height z-score (WFHZ) data. These are based on the SMART
plausibility checkers, data quality scoring, and classification criteria
implemented in the ENA for SMART software. Moreover, it provides
functions to perform data plausibility checks on Mid-Upper Arm
Circumference (MUAC) data. These are based on recent research and
recommendations concerning the MUAC-for-age z-score (MFAZ) and its
utility for assessing the plausibility of MUAC data. To learn more, see
[Plausibility check
guide](https://mphimo.github.io/mwana/articles/plausibility.html).

### 2. Prevalence estimation of acute undernutrition

`mwana` provides prevalence estimators that follow SMART guidelines on
the estimation approach to apply, based on an assessment of data
quality. These functions accept datasets containing multiple survey
domains and produce summary tables with prevalence estimates for each
domain.

### 3. IPC sample size checker

`mwana` provides a function to check whether each domain in an
anthropometric dataset meets IPC minimum sample-size requirements. The
check accounts for the data-collection mode (survey, screening exercise,
or sentinel-site surveillance). Read [IPC check
guide](https://mphimo.github.io/mwana/articles/ipc_amn_check.html).

### 4. Reporting of data plausibility checks and prevalence estimation summary outputs

`mwana` includes helper functions that process summary outputs into
presentation- or report-ready tables.

> \[!TIP\]
>
> If you are researching anthropometric data for children aged 6–59
> months (focusing on acute undernutrition), `mwana` includes functions
> to wrangle weight, height, age, WFHZ, MUAC, and MFAZ prior to
> analysis.

### Shiny App

This package has a lightweight, field-ready and convenient web-based
application (`mwanaApp`) that enables users to upload their data and
benefit from the `mwana` utilities needless to be well versed in R.
Learn more about `mwanaApp` and how to install and use
[here](https://github.com/mphimo/mwanaApp.git).

## Citation

If you use `mwana` package in your work, please cite using the suggested
citation provided by a call to
[`citation()`](https://rdrr.io/r/utils/citation.html) function as
follows:

``` r
citation("mwana")
```

``` R
To cite mwana in publications use:

  Tomás Zaba, Ernest Guevarra, Mark Myatt (2025). _mwana: An Efficient
  Workflow for Plausibility Checks and Prevalence Analysis of Wasting
  in R_. R package version 0.2.3, <https://mphimo.github.io/mwana/>.

A BibTeX entry for LaTeX users is

  @Manual{,
    title = {mwana: An Efficient Workflow for Plausibility Checks and Prevalence Analysis of Wasting in R},
    author = {{Tomás Zaba} and {Ernest Guevarra} and {Mark Myatt}},
    year = {2025},
    note = {R package version 0.2.3},
    url = {https://mphimo.github.io/mwana/},
  }
```

## Community guidelines

Feedback, bug reports and feature requests are welcome; file issues or
seek support [here](https://github.com/mphimo/mwana/issues). If you
would like to contribute to the package, please see our [contributing
guidelines](https://mphimo.github.io/mwana/CONTRIBUTING.html).

This project is released with a [Contributor Code of
Conduct](https://mphimo.github.io/mwana/CODE_OF_CONDUCT.html). By
participating in this project you agree to abide by its terms.
