# 202510-cle-open-data-addition
Some fixes to the data

Correction proposition to the mismatch between the birthdate and burialdate and the ages, and completion of some missing sex following the names, Johns are males, Marys are females.

This code follows the data analysis started by Alec Wong of Cleveland data laundry available at: https://github.com/awong234/data-laundry/tree/main/datasets/202510-cle-open-data.

Needed packages:
    arcgis,
    dplyr,
    gender,
    ggplot2,
    hms,
    lubridate,
    stringr,

Todo: A routine to sample the final result and provide the proportion of correct sex assigned would be interesting here.

For the gender package and function please check:
   Lincoln Mullen (2021). gender: Predict Gender from Names Using
   Historical Data. R package version 0.6.0.
