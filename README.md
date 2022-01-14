# globaltest_operator



##### Description

The `globaltest_operator` performs a global hypothesis test for association of groups of variables, covariates, features with a response or grouping variable.
This is a Tercen wrapper for the R-package `globaltest`.

##### Usage

Input projection|.
---|---
`row`           | Variables of interest, a global test is performed for each cell in a Tercen cross tab
`column`        | Variables of interest, a global test is performed for each cell in a Tercen cross tab
`y-axis`        | numeric, values to perform the test on
`x-axis`        | factor, x-axis must identifie the variables / co-variates for the test
`labels`        | single factor, use a single factor as label to identify the observations for the test
`colots`        | single variable, use a single variable (numeric or factor) tp identify the resposne variable for the test

Input parameters|.
---|---
`standardize`        | boolean to indicate if variables must be standardized priot to the analysis (dft = true)
`directional`        | boolean to indicate if variables are expected to have to same directionality with response (dft = FALSE)
`modeltype`          | property indicating the modeltype: `auto`, `linear`, `logistic`, `multinomial`. The default = auto, in which case the modeltype is inferred from the properties of the response variable

Output relations|.
---|---
`p`        | p-value of the test
`globaltest.statistic`        | statistic of the global test 
`nVariables` | number of variables in the test
`logp` | -log10(p)
`delta` | difference between group means, only calculated if `response` is a binary factor

##### Details

Details on the computation.

##### References

  Jelle J. Goeman and Jan Oosting (2020) Globaltest R package, version 5.44.0. [https://bioconductor.org/packages/release/bioc/html/globaltest.html]

  Jelle J. Goeman, Sara A. van de Geer, Hans C. van Houwelingen (2006) Testing against a high-dimensional
  alternative, Journal of the Royal Statistical Society, Series B, 68, 477-493.

  Jelle J. Goeman, Sara A. van de Geer, Floor de Kort, Hans C. van Houwelingen (2004) A global test for groups
  of genes: testing association with a clinical outcome. Bioinformatics 20, 93-99.
  
##### See Also

For an example in Tercen: [https://tercen.com/rdewijn/p/e6c57e18528e365a2a68566f6a7fb03f]
