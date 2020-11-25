function agg_price_index(σ,ind_prices)
    p = sum(ind_prices.^(1-σ))
    return p
end
