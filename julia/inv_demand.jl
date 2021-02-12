function inv_demand(ρ,A,w,l,η)
    p = ρ/(ρ-1).*w./(A.*l.^η)
    return p
end
