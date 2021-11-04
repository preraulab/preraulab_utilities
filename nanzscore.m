function [zscored] = nanzscore(data)

if any(isnan(data))
    mu = nanmean(data);
    sigma = nanstd(data);
    zscored = (data-mu)./sigma;
else
    zscored = zscore(data);
end

end

