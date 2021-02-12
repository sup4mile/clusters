function ind_price_index(ρ,μ_lb,μ_ub,ind_count_prices)
    p = sum(((μ_ub-μ_lb).*ind_count_prices).^(1-ρ),dims=1).^(1/(1-ρ))
    return p
end
