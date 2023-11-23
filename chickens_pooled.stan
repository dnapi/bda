data {
  int<lower=0> N_observations;
  int<lower=0> N_diets;
  array[N_observations] int diet_idx; // Pair observations to their diets.
  vector[N_observations] weight;
}

parameters {
  // Average weight of chicks with a given diet.
  vector[N_diets] mean_diet;
  //real mean_diet;

  // Standard deviation of weights observed among chicks sharing a diet.
  vector<lower=0>[N_diets] sd_diet;
  //real sd_diet;
}

model {
  // Priors
  // These look bad. I need to think about these again.

  for (diet in 1:N_diets) {
    //mean_diet[diet] ~ normal(355, 5);
    mean_diet[diet] ~ normal(525, 80);
    sd_diet[diet] ~ exponential(.02);
  }
  
  //  mean_diet ~ normal(355, 5);
  //  sd_diet ~ exponential(.02);

  // Likelihood here we use only one value from vector random vectors 
  // mean_diet, sd_diet. we choose the 4th component 
  // in this way we don't distinguish between the diets
  //for (obs in 1:N_observations) {
  //  weight[obs] ~ normal(mean_diet[4], sd_diet[4]);
  //  //weight[obs] ~ normal(mean_diet, sd_diet);
  //}
// Likelihood
//  for (obs in 1:N_observations) {
//    weight[obs] ~ normal(mean_diet[diet_idx[obs]], sd_diet[diet_idx[obs]]);
//  }

  // Best practice would be to write the likelihood without the for loop as:
    weight ~ normal(mean_diet[diet_idx], sd_diet[diet_idx]);
    
}

generated quantities {
  real weight_pred;
  real mean_five;
  // The below is just there to make the plotting in the template work with the "wrong model". 
  real sd_diets = sd_diet[4];
  //real sd_diets = sd_diet;

  // Sample from the (posterior) predictive distribution of the fourth diet.
  weight_pred = normal_rng(mean_diet[4], sd_diet[4]);

  // Construct samples of the mean of the fifth diet.
  // We only have the prior...
  // we sample directly from the same pooled model. 
  mean_five = mean_diet[4];
  //mean_five = mean(mean_diet);
  
  
}
