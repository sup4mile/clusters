# Lecture Note 3: Exact Hat Algebra in a Multi-Sector Eaton–Kortum Model with Input-Output Linkages

In this lecture note we are adding input-output linkages to the $J$-sector model in Lecture Note 2. Firms will produce varieties using intermediate inputs sourced from their own sector and/or other sectors in addition to labor. These input-output linkages are what allows a shock in one sector (say, a tariff on steel) to affect costs, prices, and trade patterns in sectors that are not directly targeted by the shock (say, automobiles), purely through the input-output structure of production.

## 1. Motivation

Lecture Note 2 introduced $J>1$ sectors but kept production a "pure value-added" activity: labor was the only input, and $c_i^j = w_i$ was the same across every sector within a country indexed by $i$. This environment highlights the role of sectoral comparative advantage and labor reallocation without the added complexity of intermediate inputs.

Real production is not like this. A car is made of steel, glass, electronics, and rubber, in addition to the labor of assembling them, and many of those inputs are themselves produced using inputs from yet other sectors. This lecture note relaxes the pure value-added assumption: firms in sector $j$ combine labor with a bundle of intermediate inputs from sector $k \in \{1,\ldots,J\}$, including $k=j$. This is the "cost propagates through supply chains" mechanism flagged but not modeled in Lecture Note 2.

The added realism comes at a cost. The presence of input-output linkages breaks some of the closed-form results (in particular, the welfare formula) that made the pure value-added model in Lecture Note 2 so tractable.

## 2. The Environment

The economy is populated by $N$ countries and $J$ sectors as in Lecture Note 2. The household's preferences are the same as before.

**Preferences.** The representative household in country $n$ has Cobb-Douglas preferences across sectors,

$$U_n = \prod_{j=1}^J \left(C_n^j\right)^{\alpha_n^j}, \qquad \sum_{j=1}^J \alpha_n^j = 1,$$

and CES love-of-variety preferences within each sector, $C_n^j = \left(\int_0^1 c_n^j(\omega)^{\frac{\sigma-1}{\sigma}}\, d\omega\right)^{\frac{\sigma}{\sigma-1}}$. Recall from Appendix A in Lecture Note 1 that $\sigma$ will not appear in anything that follows.

**Technology.** The firm producing variety $\omega$ in sector $j$ in country $i$ draws a productivity $z_i^j(\omega)$ from the Fréchet distribution $F_i^j(z) = \exp(-T_i^j z^{-\theta^j})$. In contrast to production in the first two notes, each firm now combines labor **and** intermediate inputs from every sector to produce a particular variety $\omega$ in sector $j$:

$$y_i^j(\omega) = z_i^j(\omega) \, \left[\ell_i^j(\omega)\right]^{\gamma_i^{j,0}} \prod_{k=1}^J \left[m_i^{j,k}(\omega)\right]^{\gamma_i^{j,k}},$$

where $m_i^{j,k}(\omega)$ is the quantity of the sector-$k$ composite good $C_i^k$ that firm $\omega$ uses as an intermediate input, and the exponents satisfy

$$\gamma_i^{j,0} + \sum_{k=1}^J \gamma_i^{j,k} = 1.$$

The production function as constant returns to scale with respect to labor and intermediate inputs jointly.

$\gamma_i^{j,0}$ is the **value-added share** of sector $j$ in country $i$ (the total wage bill as a fraction gross output) and $\gamma_i^{j,k}$ is the share of costs paid for intermediate inputs used in sector $j$ and sourced from sector $k$. Setting $\gamma_i^{j,0} = 1$ (and hence $\gamma_i^{j,k}=0$ for every $k$) recovers the pure value-added model of Lecture Note 2.

**Costs.** Because the production function is Cobb-Douglas in labor and the $J$ intermediate bundles, standard cost minimization delivers a unit cost of the form

$$c_i^j = B_i^j \, (w_i)^{\gamma_i^{j,0}} \prod_{k=1}^J \left(P_i^k\right)^{\gamma_i^{j,k}},$$

where $P_i^k$ is country $i$'s price index for the sector $k$ composite good $C_i^k$ and $B_i^j$ is a constant depending only on the cost shares $\{\gamma_i^{j,0}, \gamma_i^{j,1}, \dots, \gamma_i^{j,J}\}$. $B_i^j$ plays the same "harmless constant" role that $A$ played for the price index in Lecture Note 1.

This is the central new object relative to Lecture Note 2: the cost of production in sector $j$ now depends on the price indices of every sector, not just the country-wide wage $w_i$. This is the formal channel through which a shock to sector $k$'s prices spreads to every sector $j$ that uses $k$ as an input.

**Trade costs.** International trade is subject to sector-origin-destination-specific iceberg costs $d_{ni}^j \geq 1$, as in Lecture Note 2.

## 3. Trade Shares, Price Indices, and the "hat" Algebra

The trade share and price index formulae are identical to the corresponding expressions in Lecture Note 2, except that $c_i^j$ now reflects the richer cost function of Section 2 above rather than simply $w_i$:

$$\pi_{ni}^j = \frac{T_i^j \left(c_i^j d_{ni}^j\right)^{-\theta^j}}{\Phi_n^j}, \qquad \Phi_n^j = \sum_{k=1}^N T_k^j \left(c_k^j d_{nk}^j\right)^{-\theta^j},$$

and

$$P_n^j = A^j \left(\Phi_n^j\right)^{-1/\theta^j}.$$

The hat-algebra derivation for $\hat\pi_{ni}^j$ and $\hat P_n^j$ goes through exactly as in Lecture Notes 1 and 2:

$$\hat{\pi}_{ni}^j = \frac{\hat{T}_i^j \left(\hat{c}_i^j \hat{d}_{ni}^j\right)^{-\theta^j}}{\displaystyle\sum_{k=1}^N \pi_{nk}^j\, \hat{T}_k^j \left(\hat{c}_k^j \hat{d}_{nk}^j\right)^{-\theta^j}}, \qquad \hat{P}_n^j = \left[\sum_{k=1}^N \pi_{nk}^j\, \hat{T}_k^j \left(\hat{c}_k^j \hat{d}_{nk}^j\right)^{-\theta^j}\right]^{-1/\theta^j}.$$

What is new is the expression for $\hat c_i^j$ itself. Taking hats of the cost function in Section 2 it is immediately clear that the constant $B_i^j$ drops out, in the same way that $A^j$ drops out $\hat P_n^j$):

$$\hat{c}_i^j = \left(\hat{w}_i\right)^{\gamma_i^{j,0}} \prod_{k=1}^J \left(\hat{P}_i^k\right)^{\gamma_i^{j,k}}.$$

This is the key linkage equation. It says that the change in sector $j$'s cost in country $i$ is a Cobb-Douglas combination of the wage change and the price changes of every sector's output in country $i$. Since $\hat P_i^k$ is itself determined by cost changes $\hat c_i^k$ in every sector, the system is fully simultaneous across sectors within a country: one cannot solve for one sector's prices while holding the others fixed, even for a shock that directly hits only one sector.

## 4. Closing the Model (General Equilibrium)

**Sectoral expenditures.** Spending on sector $j$ output in country $n$ now has two sources: final consumption, and demand from *every* sector $k$ using sector $j$ as an intermediate input:

$$X_n^j = \alpha_n^j\, I_n + \sum_{k=1}^J \gamma_n^{k,j}\, R_n^k, \qquad I_n \equiv w_n L_n + D_n.$$

As in Lecture Note 2, take $D_n \equiv 0$ for now.

**Sectoral revenues.** Revenues in sector $j$ in country $i$ are given by:

$$R_i^j = \sum_{n=1}^N \pi_{ni}^j X_n^j.$$

**Labor market clearing.** In contrast to Lecture Note 2, not all of a sector's revenue is a payment to labor, only the value-added share $\gamma_i^{j,0}$ is. The rest is paid out to (domestic and foreign) suppliers of intermediate inputs. Country $i$'s wage bill is therefore:

$$w_i L_i = \sum_{j=1}^J \gamma_i^{j,0}\, R_i^j.$$

**General equilibrium in changes.** Writing the counterfactual system in the same hats-and-primes notation as before:

$$R_i^{j\prime} = \sum_{n=1}^N \pi_{ni}^j\, \hat{\pi}_{ni}^j\, X_n^{j\prime}, \qquad X_n^{j\prime} = \alpha_n^j \left(\hat{w}_n w_n L_n + D_n\right) + \sum_{k=1}^J \gamma_n^{k,j}\, R_n^{k\prime}, \qquad \hat{w}_i\, w_i L_i = \sum_{j=1}^J \gamma_i^{j,0}\, R_i^{j\prime}.$$

**Solving the system.** The solution algorithm has an extra layer relative to Lecture Note 2, precisely because of the point made at the end of Section 3: for a *given* guess of wage changes $\{\hat w_i\}$, the price changes $\{\hat P_i^j\}_{j=1}^J$ within each country are themselves the solution to a simultaneous system across sectors (since $\hat c_i^j$ depends on every $\hat P_i^k$, which depends on every $\hat c_i^k$, and so on). A typical algorithm therefore nests two loops:

1. **Outer loop.** Guess a vector of wage changes $\{\hat{w}_i^{(0)}\}$.
2. **Inner loop.** Given the wage guess, solve the linked system of trade share and price index equations across *all* $J$ sectors simultaneously (e.g., by iterating on $\{\hat c_i^j\} \to \{\hat \pi_{ni}^j\} \to \{\hat P_i^j\} \to \{\hat c_i^j\}$ until this inner system converges).
3. Use the converged $\{\hat\pi_{ni}^j\}$ to compute $\{X_n^{j\prime}\}$ and $\{R_i^{j\prime}\}$, and check labor-market clearing.
4. Update the wage guess $\{\hat w_i^{(1)}\}$ and repeat the outer loop until it, too, converges.

The data required to calibrate this model must be richer than those laid out in Lecture Note 2: sector-level baseline trade shares $\pi_{ni}^j$, consumption shares $\alpha_n^j$, sectoral trade elasticities $\theta^j$, and the full input-output matrix $\{\gamma_i^{j,k}\}_{j,k=1}^J$ for every country $i$ (in practice, taken from national input-output tables).

## 5. Welfare

It is tempting to guess that the welfare formula simply carries over from Lecture Note 2. It does not, and working out exactly why is instructive. Before doing so, it is worth revisiting the formula in Lecture Note 2 first.

**A correction to Lecture Note 2.** Re-deriving that formula carefully (using the boxed trade-share equation together with $d_{nn}^j=1$, so that $\hat\pi_{nn}^j = \hat{T}_n^j (\hat w_n)^{-\theta^j} / \left[\sum_k \pi_{nk}^j \hat T_k^j (\hat w_k \hat d_{nk}^j)^{-\theta^j}\right]$, and noting that the bracketed term is exactly $(\hat P_n^j)^{-\theta^j}$) gives $\hat P_n^j = \hat w_n (\hat T_n^j)^{-1/\theta^j} (\hat\pi_{nn}^j)^{1/\theta^j}$. Assuming no direct shock to country $n$'s own sectoral productivity ($\hat T_n^j = 1$), aggregating across sectors with the Cobb-Douglas weights, and using $\hat W_n = \hat w_n/\hat P_n$, the $\hat w_n$ terms **cancel completely**, leaving:

$$\hat{W}_n = \prod_{j=1}^J \left(\hat{\pi}_{nn}^j\right)^{-\alpha_n^j/\theta^j}.$$

This differs from the formula stated in Lecture Note 2 (which has an extra factor of $\hat w_n$ and the opposite sign on the exponent). The corrected version above is the direct multi-sector analogue of Lecture Note 1's $\hat W_n = (\hat\pi_{nn})^{-1/\theta}$: it is a weighted geometric average of *sector-level* home-share formulas, with weights $\alpha_n^j/\theta^j$, and — just as in the one-sector case — the wage change drops out entirely. The next edition of these lecture notes will correct this mistake in the second note.

**Why input-output linkages break this.** The cancellation above relied on $\hat c_n^j = \hat w_n$, which is the simplification that made Lecture Note 2's cost function trivial. With input-output linkages, $\hat c_n^j = (\hat w_n)^{\gamma_n^{j,0}} \prod_k (\hat P_n^k)^{\gamma_n^{j,k}}$ instead. Repeating the same steps (using $\hat\pi_{nn}^j$ and $d_{nn}^j=1$) gives, for each sector $j$:

$$\hat{P}_n^j = \hat{c}_n^j\, (\hat{T}_n^j)^{-1/\theta^j} \left(\hat{\pi}_{nn}^j\right)^{1/\theta^j} = (\hat w_n)^{\gamma_n^{j,0}} \prod_{k=1}^J \left(\hat P_n^k\right)^{\gamma_n^{j,k}} \cdot (\hat{T}_n^j)^{-1/\theta^j} \left(\hat{\pi}_{nn}^j\right)^{1/\theta^j}.$$

This is no longer a formula that expresses $\hat P_n^j$ directly in terms of observables: the unknowns $\{\hat P_n^k\}_{k=1}^J$ appear on both sides of the equation, coupled together through the country's own input-output matrix $\{\gamma_n^{j,k}\}$. Taking logs, this is a *linear system* in $\{\log \hat P_n^j\}_{j=1}^J$:

$$\log \hat{P}_n^j = \gamma_n^{j,0} \log \hat{w}_n + \sum_{k=1}^J \gamma_n^{j,k} \log \hat{P}_n^k + \frac{1}{\theta^j}\log\hat\pi_{nn}^j - \frac{1}{\theta^j}\log \hat T_n^j,$$

which can be solved in closed form via a Leontief inverse of the country's input-output matrix, but this is no longer a simple product of home trade share. Rather, the exponents that end up multiplying each $\log \hat\pi_{nn}^j$ term after solving the linear system depend on the entire input-output structure $\{\gamma_n^{j,k}\}_{j,k}$, not just on $\alpha_n^j/\theta^j$ as before.

Once intermediate inputs are added, there is, in general, no shortcut around solving the full general equilibrium system of Section 4 to compute welfare. The sector-specific home trade shares are still part of the calculation, but the enter the welfare calculation in way that takes the input-output structure into account, not just the final-consumption weights $\alpha_n^j$.

Under certain assumptions — most notably, a common trade elasticity $\theta^j = \theta$ across all sectors — Arkolakis, Costinot, and Rodríguez-Clare (2012) show that a clean sufficient-statistic result can be recovered, using an appropriately defined domestic share of gross expenditure (final consumption plus intermediate use) rather than final consumption alone. Deriving that special case is a good extension exercise, but it relies on the common-$\theta$ assumption in a way the general case here does not.

## 6. What is the Value Added of Including Input-Output Linkages?

Relative to Lecture Note 2, input-output linkages add a channel through which sector-specific shocks propagate through other sectors within a country, even absent any wage response. In Lecture Note 2, a trade-cost shock confined to sector 1 could only affect sector 2's trade pattern through the single countrywide wage $\hat w_i$ (i.e., through the general equilibrium effect).

Here, it can also affect sector 2 directly through $\hat P_i^1$, whenever sector 2 uses sector 1 as an input ($\gamma_i^{2,1} > 0$) — this is true even in a hypothetical world with a fixed wage. This is precisely the "tariff on steel raises the cost of cars" mechanism motivated in Section 1, and it is also the reason the clean sufficient-statistic welfare result of the earlier lecture notes does not survive unmodified: once sectors are linked on the cost side, a full accounting of how much of every sector's cost increase is attributable to home-produced versus imported inputs is unavoidable.
