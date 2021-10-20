function x = comp_percentile(data,value)
    percentile_range = 1:0.05:100;
    perc = prctile(data, percentile_range);
    
    x = zeros(length(value),1);
    for ii = 1:length(value)
        [~, index] = min(abs(perc'-value(ii)));
        x(ii) = percentile_range(index+1);
    end
    
end
