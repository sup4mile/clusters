# Lecture Note 2: Exact Hat Algebra in  Multi-Sector Eaton–Kortum Model 
In this lecture note we are introducing multiple sectors. For now, we abstract from input-output linkages. In other words, despite the additional complexity this is still a pure value-added model.

The third lecture note will add input-output linkages within and across sectors.

## 1. Motivation

The first handout reviewed the exact hat algebra in the context of a plain-vanilla single-sector Eaton-Kortum model.

In the quantitative trade and spatial literature, recent work introduced additional features in order to bring the model closer to the observed data. Two common extensions are (1) multiple sectors and (2) input-output linkages (i.e., a departure from a pure value-added model). The latter introduces intermediate inputs from a firm's own sector and/or other sectors, which is what allowed a tariff on, say, steel to raise costs in the auto industry even without any direct tariff on cars.

It is pedagogically useful to isolate the effects of multiple sectors *by themselves* , before we add the complication of intermediate inputs. This intermediate model with $J>1$ sectors, each with its own trade elasticity $\theta^j$ and its own trade pattern. For simplicity, production still uses only a single input: labor.

The model can address additional features of the data. Among them are:

- **Sectoral comparative advantage**: countries can be relatively better at some sectors than others, and trade elasticities can differ by sector.
- **Labor reallocation across sectors**: a shock to one sector's trade costs can pull workers (in the sense of revenue and implicit labor demand) into or out of other sectors, since all sectors compete for the same countrywide wage $w_i$.

This version of the model does not yet capture the "cost propagates through supply chains" mechanism. This refinement is covered in the third lecture note.

## 2. The $J$-Sectors Environment

The simplest way to describe the economy with $J$ sectors is to think of each sector as a 1-sector economy.

Since we assume that each country has multiple sectors, we need to describe how these sectors are "aggregated". There are multiple ways to accomplish this, but the most intuitive approach is to start with the household's preferences over "bundles" of goods produced in these sectors. Put differently, we are going to characterize how much households value goods (and services) in the manufacturing sector, the food sector, the transportation sector, etc.

**Preferences.** The representative household in country $n$ has Cobb-Douglas preferences over goods produced in the $J$ different sectors. Let $C_n^j$ denote a "composite" good (or service) in country $n$ and sector $j$. This could be "food and beverages", for instance. Formally, the utility function is given by:

$$U_n = \prod_{j=1}^J \left(C_n^j\right)^{\alpha_n^j}, \qquad \sum_{j=1}^J \alpha_n^j = 1.$$

This unit-elastic specification of the preferences implies that the representative household in country $n$ spends a fraction $\alpha_n^j$ of its income on output from sector $j$.

Within each sector, firms produce varieties of differentiated goods, which will be indexed by $\omega \in [0,1]$ and households have love-of-variety preferences:

$$ C_n^j = \left( \int_0^1 c_n^j(\omega)^{\frac{\sigma-1}{\sigma}} d\omega \right)^{\frac{\sigma}{\sigma-1}},$$

where $\sigma$ is the elasticity of substitution between varieties.

**Technology.** Within each sector $j$, the firm producing variety $\omega$ draws a productivity from a Fréchet distribution with C.D.F.:

$$F_i^j(z) = \exp\left(-T_i^j z^{-\theta^j}\right).$$

Note that this distribution varies across countries (indexed by $i$) and sectors (indexed by $j$). Absolute advantage is governed by $T_i^j$ and thus varies by country *and* sector. Comparative advantage is governed by $\theta^j$ and varies by sector only.

Let the draw of firm $\omega$'s productivity be $z_i^j(\omega)$. The firm then produces variety $\omega$ in sector $j$ in country $i$ using the following technology:

$$ y_i^j(\omega) = z_i^j(\omega) \ell_i^j(\omega),$$

where $\ell_i^j(\omega)$ is the amount of labor used by this particular firm.

Since there is a continuum of firms, we can "re-label" these firms by their productivity $z$ in lieu of their variety $\omega$. This change of variables is a bit counter-intuitive when we identify the lowest-price producer of a variety in sector $j$ in each country. For now, simply trust me that this transformation works.

**Costs.** Since there are no intermediate inputs, the cost of producing in sector $j$ in country $i$ is just labor cost (i.e., the wage):

$$c_i^j = w_i, \quad \text{for every sector } j.$$

Note that the cost of production is the same across all sectors within a country. We do not actually assume that the wage is the same. Rather, we assume that workers can switch employers within and across sectors at zero cost, which, in turn, implies that wages are equalized across firms (and thus sectors). Sectors differ in what they produce (via $T_i^j$ and $\theta^j$).

**Trade Costs.** International trade is subject to iceberg costs, denoted $d_{ni}^j$, just like in the first lecture note.

## 3. Trade Shares, Price Indices, and the "hat" Algebra

Since $c_i^j = w_i$ for every sector, the trade share and price index formulae are reminiscent of those same expressions in the first handout:

$$\pi_{ni}^j = \frac{T_i^j \left(w_i\, d_{ni}^j\right)^{-\theta^j}}{\Phi_n^j}, \qquad \Phi_n^j = \sum_{k=1}^N T_k^j \left(w_k\, d_{nk}^j\right)^{-\theta^j},$$
and
$$P_n^j = A^j \left(\Phi_n^j\right)^{-1/\theta^j}.$$

The hat-algebra derivation also follows the same logic:

$$\hat{\pi}_{ni}^j = \frac{\hat{T}_i^j \left(\hat{w}_i\, \hat{d}_{ni}^j\right)^{-\theta^j}}{\displaystyle\sum_{k=1}^N \pi_{nk}^j\, \hat{T}_k^j \left(\hat{w}_k\, \hat{d}_{nk}^j\right)^{-\theta^j}},$$

$$\hat{P}_n^j = \left[\sum_{k=1}^N \pi_{nk}^j\, \hat{T}_k^j \left(\hat{w}_k\, \hat{d}_{nk}^j\right)^{-\theta^j}\right]^{-1/\theta^j}.$$

## 4. Closing the Model (General Equilibrium)

**Sectoral expenditures.** Without intermediate demand, all of sector $j$'s spending in country $n$ comes from final consumers only:

$$X_n^j = \alpha_n^j\, I_n, \qquad I_n \equiv w_n L_n + D_n.$$

$D_n$ introduces exogenous trade imbalances and can assume $D_n \equiv 0$ for the time being.


**Sectoral revenues.** Total revenue in country $i$, sector $j$ is given by:

$$R_i^j = \sum_{n=1}^N \pi_{ni}^j X_n^j.$$

**Labor market clearing.** Since *all* revenue in every sector is a payment to labor, country $i$'s wage bill equals the sum of revenue across all its sectors:

$$w_i L_i = \sum_{j=1}^J R_i^j$$

**General equilibrium in changes.** We can write the counterfactual system using hats for shares and wages (and $X_n^{j\prime}, R_i^{j\prime}$ for the level unknowns) as in the previous handout:

$$R_i^{j\prime} = \sum_{n=1}^N \pi_{ni}^j\, \hat{\pi}_{ni}^j\, X_n^{j\prime}, \qquad X_n^{j\prime} = \alpha_n^j \left(\hat{w}_n w_n L_n + D_n\right), \qquad \hat{w}_i\, w_i L_i = \sum_{j=1}^J R_i^{j\prime}$$

This is solved by the same iterative procedure as before: guess $\{\hat w_i\}$, compute $\{\hat\pi_{ni}^j\}$ from Section 3, compute $\{X_n^{j\prime}\}$ and $\{R_i^{j\prime}\}$, check labor-market clearing, update the wage guess, and iterate to convergence. 

The model calibration requires the following data: sector-level baseline trade shares $\pi_{ni}^j$, consumption shares $\alpha_n^j$, sectoral trade elasticities $\theta^j$, and the shock.

## 5. Welfare

Because production costs collapse to $c_i^j = w_i$ for every sector, the Arkolakis-Costinot-Rodriguez-Clare-style sufficient statistic result from the first handout goes through without modification:

$$\hat{P}_n = \prod_{j=1}^J \left(\hat{P}_n^j\right)^{\alpha_n^j}, \qquad \hat{W}_n = \frac{\hat{w}_n}{\hat{P}_n} = \hat{w}_n \prod_{j=1}^J \left(\hat{\pi}_{nn}^j\right)^{\alpha_n^j/\theta^j}$$

This is identical in form to the welfare formula in the first handout. Note that the home-share-weighted average fully captures the general equilibrium response to any shock to $T_i^j$ or $d_{ni}^j$.

## 6. What is the Value Added of Including Multiple Sectors?

Countries may have a distinct comparative advantage in a particular sector. For instance, a country might be a net exporter of varieties produced in sector 1 and a net importer of varieties produced in sector 2. The one-sector model in the first handout has only a single, economy-wide trade balance condition, by construction.

Why is this an extension worth exploring? A shock to sector 1's trade costs affects the equilibrium wage and therefore $\hat w_i \neq 1$. Since labor mobility implies that wages are equalized across sectors, a sector-specific shock will reverberate through all sectors of the economy and therefore affect trade balance across sectors. It is entirely possible that the trade balance in an individual switches from a surplus to a deficit or vice versa.