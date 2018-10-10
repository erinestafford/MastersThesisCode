function [out] = cmp_models(model1,model2, infected_real)
%CHIK_CMP_REAL_MODEL returns sum squared difference of model and data

difference = model1(1:length(infected_real'),7) + model1(1:length(infected_real'),8)  - model2(1:length(infected_real'),7) + model2(1:length(infected_real'),8);

out = sum((difference.^2));