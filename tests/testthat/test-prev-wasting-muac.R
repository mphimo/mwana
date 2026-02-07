# ==============================================================================
# 📦 Functions: mw_estimate_prevalence_muac()
# ==============================================================================


## ---- Test check: mw_estimate_prevalence_muac() ------------------------------


### When age_ratio & std != problematic & !is.null(wt) & !is.null(oedema) ----
testthat::test_that(
  "mw_estimate_prevalence_muac() yields correct estimates when oedema and survey
    weights are supplied",
  {
    #### Get the prevalence estimates ----
    p <- anthro.02 |>
      mw_estimate_prevalence_muac(
        muac = muac,
        oedema = oedema, 
        wt = wtfactor, 
        age = age
      )

    #### Expected results ----
    #### GAM estimates and uncertainty ----
    n_gam <- 118
    p_gam <- 5.6
    p_gam_lci <- 4.3
    p_gam_uci <- 6.9
    deff <- 1.86

    #### SAM estimates and uncertainty ----
    n_sam <- 29
    p_sam <- 1.7
    p_sam_lci <- 0.9
    p_sam_uci <- 2.4

    #### MAM estimates and uncertainty ----
    n_mam <- 89
    p_mam <- 4.0
    p_mam_lci <- 3.0
    p_mam_uci <- 4.9

    #### Tests ----

    testthat::expect_equal(p[[1]][1], n_gam)
    testthat::expect_equal(round(p[[2]][1] * 100, 1), p_gam)
    testthat::expect_equal(round(p[[3]][1] * 100, 1), p_gam_lci)
    testthat::expect_equal(round(p[[4]][1] * 100, 1), p_gam_uci)
    testthat::expect_equal(p[[6]][1], n_sam)
    testthat::expect_equal(round(p[[7]][1] * 100, 1), p_sam)
    testthat::expect_equal(round(p[[8]][1] * 100, 1), p_sam_lci)
    testthat::expect_equal(round(p[[9]][1] * 100, 1), p_sam_uci)
    testthat::expect_equal(p[[11]][1], n_mam)
    testthat::expect_equal(round(p[[12]][1] * 100, 1), p_mam)
    testthat::expect_equal(round(p[[13]][1] * 100, 1), p_mam_lci)
    testthat::expect_equal(round(p[[14]][1] * 100, 1), p_mam_uci)
  }
)


### When age_ratio & std != problematic & is.null(wt) & !is.null(oedema) ----
testthat::test_that(
  "mw_estimate_prevalence_muac() yields correct estimates survey
    weights are not supplied",
  {
    #### Get the prevalence estimates ----
    p <- anthro.02 |>
      mw_estimate_prevalence_muac(
        muac = muac,
        age = age, 
        wt = NULL
      )

    #### Expected results ----
    #### GAM estimates and uncertainty ----
    n_gam <- 106
    p_gam <- 4.9
    p_gam_lci <- 3.8
    p_gam_uci <- 5.9

    #### SAM estimates and uncertainty ----
    n_sam <- 16
    p_sam <- 0.7
    p_sam_lci <- 0.4
    p_sam_uci <- 1.1

    #### MAM estimates and uncertainty ----
    n_mam <- 90
    p_mam <- 4.1
    p_mam_lci <- 3.2
    p_mam_uci <- 5.1

    #### Tests ----
    testthat::expect_equal(p[[1]][1], n_gam)
    testthat::expect_equal(round(p[[2]][1] * 100, 1), p_gam)
    testthat::expect_equal(round(p[[3]][1] * 100, 1), p_gam_lci)
    testthat::expect_equal(round(p[[4]][1] * 100, 1), p_gam_uci)
    testthat::expect_equal(p[[6]][1], n_sam)
    testthat::expect_equal(round(p[[7]][1] * 100, 1), p_sam)
    testthat::expect_equal(round(p[[8]][1] * 100, 1), p_sam_lci)
    testthat::expect_equal(round(p[[9]][1] * 100, 1), p_sam_uci)
    testthat::expect_equal(p[[11]][1], n_mam)
    testthat::expect_equal(round(p[[12]][1] * 100, 1), p_mam)
    testthat::expect_equal(round(p[[13]][1] * 100, 1), p_mam_lci)
    testthat::expect_equal(round(p[[14]][1] * 100, 1), p_mam_uci)
  }
)


### When age_ratio & std != problematic & !is.null(wt) & !is.null(oedema) ----
testthat::test_that(
  "mw_estimate_prevalence_muac() yields correct estimates when oedema is not
    supplied",
  {
    #### Get the prevalence estimates ----
    p <- anthro.02 |>
      mw_estimate_prevalence_muac(
        muac = muac,
        age = age, 
        oedema = NULL, 
        wt = wtfactor
      )

    #### Expected results ----
    #### GAM estimates and uncertainty ----
    n_gam <- 106
    p_gam <- 5.0
    p_gam_lci <- 3.8
    p_gam_uci <- 6.2
    deff <- 1.75

    #### SAM estimates and uncertainty ----
    n_sam <- 16
    p_sam <- 0.9
    p_sam_lci <- 0.4
    p_sam_uci <- 1.5

    #### MAM estimates and uncertainty ----
    n_mam <- 90
    p_mam <- 4.0
    p_mam_lci <- 3.1
    p_mam_uci <- 5.0

    #### Tests ----
    testthat::expect_equal(p[[1]][1], n_gam)
    testthat::expect_equal(round(p[[2]][1] * 100, 1), p_gam)
    testthat::expect_equal(round(p[[3]][1] * 100, 1), p_gam_lci)
    testthat::expect_equal(round(p[[4]][1] * 100, 1), p_gam_uci)
    testthat::expect_equal(p[[6]][1], n_sam)
    testthat::expect_equal(round(p[[7]][1] * 100, 1), p_sam)
    testthat::expect_equal(round(p[[8]][1] * 100, 1), p_sam_lci)
    testthat::expect_equal(round(p[[9]][1] * 100, 1), p_sam_uci)
    testthat::expect_equal(p[[11]][1], n_mam)
    testthat::expect_equal(round(p[[12]][1] * 100, 1), p_mam)
    testthat::expect_equal(round(p[[13]][1] * 100, 1), p_mam_lci)
    testthat::expect_equal(round(p[[14]][1] * 100, 1), p_mam_uci)
  }
)


### When age_ratio != problematic & is.null(wt) ----
testthat::test_that(
  "mw_estimate_prevalence_muac() yields correct estimates when oedema is not supplied",
  {
    #### Get prevalence estimates ----
    p <- anthro.02 |>
      mw_estimate_prevalence_muac(
        muac = muac,
        age = age, 
        oedema = NULL
      )

    #### Expected results ----
    #### GAM estimates and uncertainty ----
    n_gam <- 106
    p_gam <- 4.9
    p_gam_lci <- 3.8
    p_gam_uci <- 5.9

    #### SAM estimates and uncertainty ----
    n_sam <- 16
    p_sam <- 0.7
    p_sam_lci <- 0.4
    p_sam_uci <- 1.1

    #### MAM estimates and uncertainty ----
    n_mam <- 90
    p_mam <- 4.1
    p_mam_lci <- 3.2
    p_mam_uci <- 5.1

    #### The test ----
    testthat::expect_equal(p[[1]][1], n_gam)
    testthat::expect_equal(round(p[[2]][1] * 100, 1), p_gam)
    testthat::expect_equal(round(p[[3]][1] * 100, 1), p_gam_lci)
    testthat::expect_equal(round(p[[4]][1] * 100, 1), p_gam_uci)
    testthat::expect_equal(p[[6]][1], n_sam)
    testthat::expect_equal(round(p[[7]][1] * 100, 1), p_sam)
    testthat::expect_equal(round(p[[8]][1] * 100, 1), p_sam_lci)
    testthat::expect_equal(round(p[[9]][1] * 100, 1), p_sam_uci)
    testthat::expect_equal(p[[11]][1], n_mam)
    testthat::expect_equal(round(p[[12]][1] * 100, 1), p_mam)
    testthat::expect_equal(round(p[[13]][1] * 100, 1), p_mam_lci)
    testthat::expect_equal(round(p[[14]][1] * 100, 1), p_mam_uci)
  }
)


### When age ratio != problematic & !is.null(wt) by grouped vars
testthat::test_that(
  "mw_estimate_prevalence_muac() yields correct estimates when grouping variables are
    specified",
  {
    #### Get prevalence estimates ----
    p <- anthro.02 |>
      mw_estimate_prevalence_muac(
        muac = muac,
        oedema = oedema,
        age = age,
        wt = wtfactor,
        province
      )

    #### Expected results for Zambezia province ----
    #### GAM estimates and uncertainty ----
    n_gam <- 57
    p_gam <- 5.5
    p_gam_lci <- 3.8
    p_gam_uci <- 7.2
    deff <- 1.67

    #### SAM estimates and uncertainty ----
    n_sam <- 10
    p_sam <- 1.3
    p_sam_lci <- 0.4
    p_sam_uci <- 2.2

    #### MAM estimates and uncertainty ----
    n_mam <- 47
    p_mam <- 4.2
    p_mam_lci <- 3.0
    p_mam_uci <- 5.4

    #### Sum of weigths ----
    sum_wt <- 880902

    #### The test ----
    testthat::expect_equal(p[[2]][2], n_gam)
    testthat::expect_equal(round(p[[3]][2] * 100, 1), p_gam)
    testthat::expect_equal(round(p[[4]][2] * 100, 1), p_gam_lci)
    testthat::expect_equal(round(p[[5]][2] * 100, 1), p_gam_uci)
    testthat::expect_equal(round(p[[6]][2], 2), deff)
    testthat::expect_equal(p[[7]][2], n_sam)
    testthat::expect_equal(round(p[[8]][2] * 100, 1), p_sam)
    testthat::expect_equal(round(p[[9]][2] * 100, 1), p_sam_lci)
    testthat::expect_equal(round(p[[10]][2] * 100, 1), p_sam_uci)
    testthat::expect_equal(p[[12]][2], n_mam)
    testthat::expect_equal(round(p[[13]][2] * 100, 1), p_mam)
    testthat::expect_equal(round(p[[14]][2] * 100, 1), p_mam_lci)
    testthat::expect_equal(round(p[[15]][2] * 100, 1), p_mam_uci)
    testthat::expect_equal(p[[17]][2], sum_wt)
  }
)


### When different analaysis approaches are applied ----
testthat::test_that(
  "mw_estimate_prevalence_muac() works well on a dataframe with multiple survey areas with
    different categories of analysis_approach",
  {
    #### Get the prevalence estimates ----
    p <- anthro.04 |>
      mw_wrangle_age(age = age) |> 
      mw_wrangle_muac(sex, muac, age, FALSE, TRUE, "cm") |> 
      mutate(muac = recode_muac(muac, "mm")) |> 
      mw_estimate_prevalence_muac(
        muac = muac,
        age = age, 
        oedema = oedema, 
        wt = NULL, 
        analysis_unit
      )

    columns_to_check <- c(
      "gam_p_low", "gam_p_upp", "sam_p_low", "sam_p_upp", "mam_p_low", "mam_p_upp"
    )

    ### The test ----
    testthat::expect_vector(select(p, !analysis_unit), size = 3, ncol(17))
    testthat::expect_s3_class(p, "tbl")
    testthat::expect_false(all(sapply(p[1, ][columns_to_check], \(.) all(is.na(.)))))
    testthat::expect_true(all(sapply(p[2, ][columns_to_check], \(.) all(is.na(.)))))

    #### Unit B: age-weighted prevalence ----
    testthat::expect_true(is.na(p[2, 2][[1]]))
    testthat::expect_equal(round(p[2, 3][[1]] * 100, 1), 12.1)
    testthat::expect_true(is.na(p[2, 4][[1]]))
    testthat::expect_equal(round(p[2, 8][[1]] * 100, 1), 2.9)
    testthat::expect_true(is.na(p[2, 6][[1]]))
    testthat::expect_equal(round(p[2, 13][[1]] * 100, 1), 9.2)
    testthat::expect_equal(p[2, 17][[1]], 1354)

    #### Unit C: Age ratio is problematic but prop >= 0.66 (non-age-weighted p) ----
    testthat::expect_equal(round(p[3, 3][[1]] * 100, 1), 9.1)
    testthat::expect_equal(round(p[3, 4][[1]] * 100, 1), 4.9)
    testthat::expect_equal(round(p[3, 8][[1]] * 100, 1), 2.4)
    testthat::expect_equal(round(p[3, 13][[1]] * 100, 1), 6.7)
    testthat::expect_equal(p[3, 17][[1]], 209)
  }
)


### When MUAC is not in millimetres the function errors ----
testthat::test_that(
  "When MUAC is not in centimetres, the function stop execution",
  {
    testthat::expect_error(
      x <- anthro.01 |>
        mw_wrangle_age(
          age = age,
          .decimals = 2
        ) |>
        mw_wrangle_muac(
          sex = sex,
          muac = muac,
          age = age,
          .recode_sex = FALSE,
          .recode_muac = TRUE,
          .to = "cm",
          .decimals = 3
        ) |>
        mw_wrangle_wfhz(
          sex = sex,
          weight = weight,
          height = height,
          .recode_sex = F,
          .decimals = 3
        ) |>
        mw_estimate_prevalence_muac(oedema = oedema),
      regexp = "MUAC values must be in millimetres. Please try again."
    )
  }
)
