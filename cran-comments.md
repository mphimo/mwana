## Release summary  

This is a resubmission. In this version I have:

* Removed Quarto code-annotation markers (`# <1>`, `# <2>`, ...) from
  the `ipc-amn-check` and `plausibility` vignettes and rewritten the
  corresponding explanations as prose. These markers were rendered by
  Quarto as anchor tags with empty `href` attributes, which previously
  triggered the NOTE:

  ```
  Found the following (possibly) invalid URLs:
    URL:
      From:
        inst/doc/ipc-amn-check.html
        inst/doc/plausibility.html
      Message: Empty URL
  ```

* Removed a leftover in-development version suffix (`.9000`) from
  `inst/CITATION`, syncing the version with `CITATION.cff` and
  `README.md`.

## R CMD check results

### Local checks 

0 errors | 0 warnings | 0 notes
