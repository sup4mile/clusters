# Lecture Notes (Follow-Up III): Tariffs and Trade Imbalances in Exact Hat Algebra

**Topic:** Quantitative Trade Models — Adding Tariffs and Trade Imbalances
**Prerequisites:** These notes build directly on "Exact Hat Algebra in the Eaton–Kortum Model" and "Exact Hat Algebra in a Multi-Sector Eaton–Kortum Model." We reuse their notation throughout, including sectors $j,k$, countries $i,n$, cost shares $\gamma_i^{j,k}$, and consumption shares $\alpha_n^j$.

---

## 1. Motivation

Two loose ends remain from the previous handouts:

1. **Tariffs.** So far, "trade costs" $d_{ni}^j$ have been a black box combining transport costs, tariffs, and other frictions. But tariffs are qualitatively different from transport costs in one crucial respect: an iceberg transport cost *destroys* resources in transit (part of the good simply melts away), while a **tariff is a transfer** — the exporter's price rises for the importer, but the difference is collected as government revenue, not destroyed. This distinction matters enormously for welfare and for counterfactual tariff experiments (which is, after all, one of the main uses of these models).

2. **Trade imbalances.** We have carried around a term $D_n$ — a trade deficit or surplus — since the very first handout, but treated it as an exogenous constant. Real countries run persistent trade deficits or surpluses (e.g., the U.S. trade deficit), and we need to be explicit about what $D_n$ represents and how to handle it in a counterfactual.

This handout tackles both issues together, following **Caliendo and Parro (2015)**, who extended the Dekle-Eaton-Kortum framework in exactly this direction to study NAFTA.

---

## 2. Tariffs as a wedge between producer and consumer prices

Let $\tau_{ni}^j \geq 0$ denote the **ad valorem tariff** that country $n$ imposes on sector-$j$ imports from country $i$ (with $\tau_{nn}^j = 0$: no tariff on domestic purchases). If the pre-tariff ("producer" or "free on board") price of a unit of the sector-$j$ input bundle shipped from $i$ to $n$ is $c_i^j d_{ni}^j$ (cost plus iceberg transport cost, as before), then the price actually paid by buyers in $n$ is:

$$p_{ni}^j = c_i^j\, d_{ni}^j \,\left(1 + \tau_{ni}^j\right)$$

Buyers in $n$ choose the lowest-price supplier based on this **tariff-inclusive** price. It is convenient to define $\kappa_{ni}^j \equiv 1 + \tau_{ni}^j$ as the **tariff factor**, so $p_{ni}^j = c_i^j d_{ni}^j \kappa_{ni}^j$.

**Trade shares.** Repeating the Fréchet derivation from the first handout, but with buyers comparing tariff-inclusive prices:

$$\pi_{ni}^j = \frac{T_i^j \left(c_i^j d_{ni}^j \kappa_{ni}^j\right)^{-\theta^j}}{\Phi_n^j}, \qquad \Phi_n^j = \sum_{k=1}^N T_k^j \left(c_k^j d_{nk}^j \kappa_{nk}^j\right)^{-\theta^j}$$

This is identical to the multi-sector formula from Handout II, with $d_{ni}^j$ simply replaced by $d_{ni}^j \kappa_{ni}^j$. Since the tariff factor enters exactly like an iceberg cost in this equation, the **hat-algebra derivation goes through unchanged**: define $\hat{\kappa}_{ni}^j \equiv \kappa_{ni}^{j\prime}/\kappa_{ni}^j$ as the proportional change in one plus the tariff, and we immediately obtain:

$$\boxed{\hat{\pi}_{ni}^j = \frac{\hat{T}_i^j \left(\hat{c}_i^j \hat{d}_{ni}^j \hat{\kappa}_{ni}^j\right)^{-\theta^j}}{\displaystyle\sum_{k=1}^N \pi_{nk}^j\, \hat{T}_k^j \left(\hat{c}_k^j \hat{d}_{nk}^j \hat{\kappa}_{nk}^j\right)^{-\theta^j}}}$$

**A tariff cut on route $(n,i)$ in sector $j$** is simply modeled as $\hat{\kappa}_{ni}^j < 1$ (a reduction in one plus the tariff), with everything else in the equation observable baseline data or the elasticity $\theta^j$. This is the sense in which the hat-algebra approach handles tariff counterfactuals with essentially no extra machinery — *provided* we now also track where the tariff revenue goes, which is new.

---

## 3. Tariff revenue

Even though buyers pay the tariff-inclusive price $p_{ni}^j$, only the producer-price portion $c_i^j d_{ni}^j$ actually leaves country $n$ as payment to foreign producers — the remainder is collected by country $n$'s own government as **tariff revenue**.

Total spending by country $n$ on sector-$j$ goods from source $i$ is $\pi_{ni}^j X_n^j$ (recall $X_n^j$ is $n$'s total expenditure on sector $j$). Of this, the tariff-exclusive portion transferred to the foreign producer is $\pi_{ni}^j X_n^j / \kappa_{ni}^j$, so tariff revenue collected on this particular route is:

$$\pi_{ni}^j X_n^j - \frac{\pi_{ni}^j X_n^j}{\kappa_{ni}^j} = \pi_{ni}^j X_n^j \left(\frac{\tau_{ni}^j}{1+\tau_{ni}^j}\right)$$

Summing across all sectors and source countries, country $n$'s **total tariff revenue** is:

$$R_n = \sum_{j=1}^J \sum_{i=1}^N \pi_{ni}^j X_n^j \left(\frac{\tau_{ni}^j}{1+\tau_{ni}^j}\right)$$

**Standard assumption (tariff revenue rebate).** We assume this revenue is rebated lump-sum to the representative consumer in country $n$ — the government runs a balanced budget, collecting tariffs and handing the proceeds straight back to households. This is the standard simplifying assumption in this literature; it is what allows us to write country $n$'s total spendable income cleanly, as we do next.

---

## 4. Producer revenue and trade balance

**Producer revenue.** Since only the tariff-exclusive portion of spending reaches producers, sector-$j$ revenue (total sales) in country $i$ is:

$$O_i^j = \sum_{n=1}^N \frac{\pi_{ni}^j X_n^j}{\kappa_{ni}^j}$$

(We use $O_i^j$ here, rather than $R_i^j$ as in Handout II, to free up $R_n$ for tariff revenue and avoid notational collision — a common source of confusion when reading the primary literature, so it's worth flagging explicitly.)

**Trade imbalance, defined properly.** Country $n$'s trade deficit $D_n$ is defined as the gap between what $n$ spends on foreign goods (at producer prices, i.e., what actually leaves the country) and what it earns from foreign sales of its own goods:

$$D_n = \underbrace{\sum_{j}\sum_{i \neq n} \frac{\pi_{ni}^j X_n^j}{\kappa_{ni}^j}}_{\text{payments for imports}} - \underbrace{\sum_j \sum_{m \neq n} \frac{\pi_{mn}^j X_m^j}{\kappa_{mn}^j}}_{\text{export earnings}}$$

$D_n > 0$ means country $n$ is running a trade deficit (importing more than it exports, financed by borrowing from the rest of the world or by running down assets); $D_n < 0$ is a surplus. Note $\sum_n D_n = 0$ always, since one country's deficit must be another's surplus.

**Total spendable income in country $n$** is therefore wage income, plus rebated tariff revenue, plus net borrowing from abroad (the deficit):

$$I_n = w_n L_n + R_n + D_n$$

---

## 5. Closing the model

We now update the multi-sector market-clearing system from Handout II to include tariffs and the deficit explicitly.

**Sectoral expenditure:**

$$X_n^j = \alpha_n^j\, I_n + \sum_{k=1}^J \gamma_n^{k,j}\, O_n^k$$

**Producer revenue:**

$$O_i^j = \sum_{n=1}^N \frac{\pi_{ni}^j X_n^j}{\kappa_{ni}^j}$$

**Wage income (labor market clearing):**

$$w_i L_i = \sum_{j=1}^J \gamma_i^{j,0}\, O_i^j$$

**Tariff revenue:**

$$R_n = \sum_{j}\sum_{i} \pi_{ni}^j X_n^j \left(\frac{\tau_{ni}^j}{1+\tau_{ni}^j}\right)$$

Written in changes (hats for wages, prices, and trade shares; the level equations above hold at both the baseline and the primed/counterfactual values), this is a simultaneous system in $\{\hat{w}_i\}$, $\{X_n^{j\prime}\}$, $\{O_i^{j\prime}\}$, and $\{R_n'\}$, solved the same way as before: guess wages, compute costs and trade shares, compute revenues and expenditures and tariff revenue under the *new* tariff schedule $\{\kappa_{ni}^{j\prime}\}$, check labor-market clearing, update, and iterate to convergence.

**A key modeling choice: what happens to $D_n$ in the counterfactual?** The trade deficit is a genuinely exogenous object in this class of models — nothing here explains *why* a country runs a persistent deficit. The literature typically adopts one of two conventions:

- **Fixed in levels ($D_n' = D_n$):** the dollar (or numeraire) value of the deficit is held constant across the counterfactual. This is the more common assumption (used by Caliendo and Parro) and can be interpreted as holding constant a country's net borrowing from the rest of the world.
- **Fixed as a share of income:** $D_n'/I_n' = D_n/I_n$, i.e., the deficit scales with the size of the economy.

Neither is "correct" in a deep sense — the choice matters for the results, and good applied work checks robustness to it. This is worth flagging to students as a place where the model requires an auxiliary assumption not delivered by the theory itself.

---

## 6. Welfare with tariffs: the sufficient-statistic result breaks down

Recall the elegant multi-sector ACR-type welfare formula from Handout II:

$$\hat{W}_n = \hat{w}_n \prod_{j=1}^J \left(\hat{\pi}_{nn}^j\right)^{\alpha_n^j/\theta^j}$$

This formula relied on real income being simply $w_n / P_n$. Once tariff revenue enters the picture, total income is $I_n = w_n L_n + R_n + D_n$, not just wage income, so real income (welfare) becomes:

$$\boxed{\hat{W}_n = \frac{\hat{I}_n}{\hat{P}_n}, \qquad \hat{P}_n = \prod_{j=1}^J \left(\hat{P}_n^j\right)^{\alpha_n^j}}$$

**This is an important teaching point.** The clean "sufficient statistic" property of the ACR formula — that welfare depends *only* on the change in the home trade share and the trade elasticity — is a special feature of models **without** tariffs (or more precisely, without any wedge whose proceeds are rebated domestically rather than either destroyed or paid abroad). Once tariff revenue $R_n$ is part of income, it must be computed explicitly from the full trade pattern (Section 3), and there is no shortcut that avoids solving for it. Intuitively: a tariff simultaneously (i) raises consumer prices, which is bad for welfare, but (ii) redistributes some of the resulting rents from foreigners to the domestic government, which is a partly offsetting income effect — and this second channel is exactly what breaks the clean home-share formula. Terms-of-trade effects of tariffs are the classic reason a *small* tariff can sometimes even *raise* a large country's welfare (the standard "optimal tariff" argument from international trade theory), which is precisely the channel this richer model is built to capture.

---

## 7. Summary: what's new in this handout

| Feature | Handout II (no tariffs) | Handout III (with tariffs) |
|---|---|---|
| Price wedge | Iceberg cost $d_{ni}^j$ only | Iceberg cost $d_{ni}^j$ **and** tariff factor $\kappa_{ni}^j = 1+\tau_{ni}^j$ |
| Fate of the wedge | "Melts" — a pure resource cost | Iceberg portion melts; tariff portion is collected as **revenue** |
| Country income | $w_n L_n + D_n$ | $w_n L_n + R_n + D_n$ |
| Trade balance | Exogenous deficit $D_n$ | Exogenous deficit $D_n$, defined carefully at producer prices, net of tariff revenue |
| Welfare formula | Clean sufficient statistic: $\hat w_n \prod_j (\hat\pi_{nn}^j)^{\alpha_n^j/\theta^j}$ | No closed form — must solve for $\hat I_n$ and $\hat P_n$ from the full system |
| New assumption required | — | How $D_n$ evolves in the counterfactual (fixed in levels vs. as a share of income) |

The core hat-algebra logic is completely undisturbed: unobservable levels of $T_i^j$ and $d_{ni}^j$ still cancel out of every equation, and tariffs enter through the *observable* tariff rate $\tau_{ni}^j$ (a matter of public policy, not an estimated black box), which is exactly why this framework has become the standard workhorse for quantifying the effects of real-world trade agreements and tariff wars.

---

## Suggested Exercises

1. Suppose country $n$ eliminates a tariff on sector $j$ imports from country $i$ ($\hat{\kappa}_{ni}^j < 1$) but tariff revenue was small to begin with (say sector $j$ was a tiny share of $n$'s imports). Explain, using Section 6, why the welfare change $\hat{W}_n$ in this case will be well approximated by the simple ACR-style home-trade-share formula, even though in principle tariffs invalidate it exactly.
2. Two economists disagree about how to model NAFTA's effect on Mexico: one holds $D_{\text{Mexico}}$ fixed in levels, the other holds it fixed as a share of income. If Mexican income $I_{\text{Mexico}}$ rises substantially after the counterfactual, explain how the two conventions would lead to different implied trade deficits, and discuss which channel (Section 4's $I_n$ equation) this affects directly.
3. Show algebraically that if $\tau_{ni}^j = 0$ for every $n, i, j$ (no tariffs anywhere), then $R_n = 0$ for every country, $I_n$ collapses back to $w_n L_n + D_n$, and the entire system in Section 5 collapses exactly to the multi-sector model of Handout II. This confirms that Handout II is the special "free trade policy" case of the more general model developed here.
