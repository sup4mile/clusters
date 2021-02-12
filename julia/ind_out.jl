function ind_out(ρ,μ_lb,μ_ub,ind_count_out)
    y = sum((μ_ub-μ_lb).*(ind_count_out.^((ρ-1)/ρ)),dims=1).^(ρ/(ρ-1))
    return y
end
