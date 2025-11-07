# There are two goals in this excercise:
# 1. Fix a mismatch between birthdate and burialdate with the age of the person, and
# 2. Fill some missing sex datapoints based on the name of the person.


# 1. Fixing the age of the person -----------------------------------------

# Work on those cases where the difference between age and burialdate minus birthdate is larger than -1 or 1.
# Will approach two different assumptions:
# 1. Birthdate needs to be corrected.
# 2. Age needs to be corrected.


# 1.1 Correcting birthdate ------------------------------------------------

# Calculation of the most probable birthdate for negative differences
burials |>
  mutate(Birthdate = year(birthdate), Burialdate = year(burialdate), Calculated_age = Burialdate - Birthdate) |> 
  select(Birthdate, Burialdate, age, Calculated_age) |>
  mutate(Difference = Calculated_age - age) |>
  filter(Difference < -1) |>
  # arrange(desc(Difference)) |>
  arrange(Difference) |> 
  mutate(Most_probable_birthyear = Burialdate - age) |>
  head()

# Calculation of the most probable birthdate for positive differences
burials |>
  mutate(Birthdate = year(birthdate), Burialdate = year(burialdate), Calculated_age = Burialdate - Birthdate) |> 
  select(Birthdate, Burialdate, age, Calculated_age) |>
  mutate(Difference = Calculated_age - age) |>
  filter(Difference > 1) |>
  arrange(desc(Difference)) |>
  mutate(Most_probable_birthyear = Burialdate - age) |>
  head()

# 1.2 Correcting age ------------------------------------------------------

# Calculation of the most probable age for negative differences
burials |>
  mutate(Birthdate = year(birthdate), Burialdate = year(burialdate), Calculated_age = Burialdate - Birthdate) |> 
  select(Birthdate, Burialdate, age, Calculated_age) |>
  mutate(Difference = Calculated_age - age) |>
  filter(Difference < -1) |>
  arrange(desc(Difference)) |>
  mutate(Most_probable_age = Burialdate - Birthdate) |>
  head()

# Calculation of the most probable age for positive differences
burials |>
  mutate(Birthdate = year(birthdate), Burialdate = year(burialdate), Calculated_age = Burialdate - Birthdate) |> 
  select(Birthdate, Burialdate, age, Calculated_age) |>
  mutate(Difference = Calculated_age - age) |>
  filter(Difference > 1) |>
  arrange(desc(Difference)) |>
  mutate(Most_probable_age = Calculated_age) |>
  head()


# 2. Fix sex field after the first name of the person ---------------------

# Choosing the cases where the name of the person is available and sex missing.

missing_sex <- 
  burials |> filter(!is.na(firstname) & sex == '')

# Assign a field for the first names.

missing_sex$name <- stringr::word(
  tm::removePunctuation(
    missing_sex$firstname, 1))

# Some people with missing sex data and name as 'UNKNOWN' will be ignored.
missing_sex[missing_sex$name == 'UNKNOWN', c(4, 5)]
missing_sex <- missing_sex[-which(missing_sex$name == 'UNKNOWN'), ]

unique(burials$sex)
summary(as.factor(burials$sex)) # 10.126 Missing sex by 2025-November.
min(burials$birthdate, na.rm = T) # Data used by the gender package


# Removing cases where name is only one letter

missing_sex <- missing_sex[
  -which(
    nchar(missing_sex$name) == 1
  ), 
]


# 2.1 Assign possible sex based on the first name -------------------------
# Can take some 5 to 10 mins

for (i in 1:nrow(missing_sex)) {
  genderi <- gender(missing_sex[i, 27], method = 'ipums')$gender
  ifelse(genderi == 'male' | genderi == 'female',
         missing_sex[i, 28] <- genderi,
         missing_sex[i, 28] <- 'Unknown'
  )
  cat("\r",i,' ', missing_sex[i, 4], genderi,'   ')
}

colnames(missing_sex)[28] <- 'most_probable_sex'

# Manual random check

missing_sex[
  round(runif(1, 1, nrow(missing_sex))), c(2, 27, 28)
]


# To-do: ------------------------------------------------------------------

# A routine to check the proportion of correct cases would be interesting at this point
