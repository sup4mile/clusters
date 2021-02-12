function agg_out(σ,ind_out)
    y = sum((ind_out.^((σ-1)/σ))).^(σ/(σ-1))
    return y
end
