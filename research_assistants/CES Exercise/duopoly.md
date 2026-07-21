## Assignment: Bertrand Duopoly with Weighted CES Preferences and Linear Production

### Environment

**Consumers.** A representative consumer has weighted CES preferences over two differentiated goods:
$$U(q_1, q_2) = \left(\alpha_1 q_1^{\frac{\sigma-1}{\sigma}} + \alpha_2 q_2^{\frac{\sigma-1}{\sigma}}\right)^{\frac{\sigma}{\sigma-1}}, \qquad \sigma > 1,\ \ \alpha_1 + \alpha_2 = 1,\ \ \alpha_1,\alpha_2 > 0$$

The weights $\alpha_i$ capture the consumer's relative preference intensity ("taste weight") for good $i$; they are exogenous demand-side parameters, distinct from any cost-side asymmetry. Labor supply is exogenous and inelastic at $\bar L$, wage $w$, total expenditure $E = w\bar L$.

**Production.**  $q_i = A_i \ell_i$, competitive labor market, wage $w$ taken as given.

**Market structure.**  simultaneous Bertrand price competition.

---

### Part A — Demand system

1. Maximize $U(q_1,q_2)$ subject to $p_1 q_1 + p_2 q_2 = E$. Show that the demand system is
$$q_i = \alpha_i^{\sigma}\, p_i^{-\sigma}\, P^{\sigma - 1}\, E, \qquad P \equiv \left(\alpha_1^{\sigma} p_1^{1-\sigma} + \alpha_2^{\sigma} p_2^{1-\sigma}\right)^{\frac{1}{1-\sigma}}$$
   (Confirm $P$ is the correct CES price index by checking $P_1q_1+p_2q_2 = E$ and $U = E/P$ at the optimum.)
2. Define $s_i = p_i q_i/E$. Show
$$s_i = \frac{\alpha_i^\sigma p_i^{1-\sigma}}{\alpha_1^\sigma p_1^{1-\sigma} + \alpha_2^\sigma p_2^{1-\sigma}}$$
and that the own-price elasticity is still
$$\varepsilon_i = \sigma - (\sigma-1)s_i$$
   (i.e., the elasticity *formula* is unchanged — the weights enter only through $s_i$.)

### Part B — Costs
*(Unchanged from before.)* Marginal cost $mc_i = w/A_i$, constant in $q_i$.

### Part C — Bertrand pricing

3. Write $\pi_i(p_i,p_j) = (p_i - mc_i)\,\alpha_i^\sigma p_i^{-\sigma} P^{\sigma-1} E$ and derive the first-order condition. Show it again reduces to
$$\frac{p_i - mc_i}{p_i} = \frac{1}{\varepsilon_i} = \frac{1}{\sigma - (\sigma-1)s_i}$$
4. Note that $\alpha_i$ does **not** appear directly in the markup formula — it enters only indirectly, through $s_i$. Explain intuitively why a higher taste weight $\alpha_i$, holding prices fixed, raises $s_i$ and hence *lowers* firm $i$'s markup (i.e., a more-desired good faces a *less* elastic residual demand at any given $s_i$, but reaches a higher $s_i$ in equilibrium — you should carefully disentangle the direct vs. equilibrium effect here).

### Part D — Symmetric-cost, asymmetric-taste equilibrium

5. Suppose $A_1 = A_2 = A$ (equal costs) but $\alpha_1 \ne \alpha_2$. Explain why the equilibrium is **not** symmetric in prices even though marginal costs are equal — i.e., why "symmetric equilibrium" from the unweighted case no longer applies.
6. Set up the two best-response conditions from Part C(3) as a system in $(p_1, p_2)$. Show that if $\alpha_1 = \alpha_2 = 1/2$, this collapses to the earlier symmetric case $p_1^*=p_2^*=mc\cdot\frac{\sigma}{\sigma-1}\cdot\frac{1}{1-1/(\sigma+1)}$-type expression (or whatever closed form you derived previously) — i.e., verify the earlier assignment is the special case $\alpha_1=\alpha_2$.
7. Pick numbers: $\sigma = 4$, $A_1=A_2=1$, $w=1$, $\alpha_1 = 0.7$, $\alpha_2 = 0.3$. Solve numerically (fixed-point iteration on best responses) for $(p_1^*,p_2^*)$. Which firm charges the higher price? Which has the higher markup $p_i^*/mc$? Which has the higher expenditure share $s_i^*$?

### Part E — Fully asymmetric case (costs *and* tastes)

8. Now let both $A_1 \ne A_2$ and $\alpha_1 \ne \alpha_2$. Using $\sigma=4$, $A_1=1$, $A_2=1.5$, $\alpha_1=0.7$, $\alpha_2=0.3$, $w=1$, solve numerically for $(p_1^*,p_2^*)$.
9. Decompose: relative to Part D(7) (taste asymmetry only), how does adding the productivity advantage for good 2 ($A_2>A_1$) change $p_2^*$ relative to $p_1^*$? Does the cost advantage offset, reinforce, or dominate the taste disadvantage ($\alpha_2 < \alpha_1$) in determining who has the higher equilibrium market share $s_i^*$?

### Part F — Closing the model: labor market

10. Given equilibrium prices, back out $q_1^*, q_2^*$ from $E=w\bar L$ and the demand system in Part A(1).
11. Solve for $\ell_1^*,\ell_2^*$ via $q_i^*=A_i\ell_i^*$ and verify $\ell_1^*+\ell_2^*=\bar L$.
12. As before, note that $w$ is normalized and $\bar L$ pins down the *scale* $E$ (and hence quantities and labor allocation) but not relative prices, which are determined purely by $(\sigma, \alpha_1,\alpha_2,A_1,A_2)$ — confirm this by checking that $\bar L$ never entered your price equations in Parts C–E.

### Part G — Discussion

13. Suppose you only observed equilibrium prices and expenditure shares $(p_1^*,p_2^*,s_1^*,s_2^*)$ but not $(\alpha_1,\alpha_2)$ directly. Using the demand system in Part A(1), show how you could **back out the ratio $\alpha_1/\alpha_2$** from observed data — this is the logic behind empirically estimating CES "quality" or "taste" parameters (e.g., in trade/IO demand estimation, à la Feenstra-type CES demand systems).
14. Contrast the role of $\alpha_i$ here with the role of $A_i$: both create asymmetry between the firms, but one is a **demand-side** shifter and one is a **cost-side** shifter. Explain why, in equilibrium, they are *not* observationally equivalent even though both can generate $p_1^* \ne p_2^*$ — what additional data (e.g., quantities, cost data) would let you distinguish them?

---

**Suggested baseline numerical parameters:** $\sigma=4$, $A_1=1,\ A_2=1.5$, $\alpha_1=0.7,\ \alpha_2=0.3$, $w=1$, $\bar L=100$.

Want a solution key with the numerical fixed-point iterations worked out (Parts D7 and E8), or should I leave the numbers as an open exercise?