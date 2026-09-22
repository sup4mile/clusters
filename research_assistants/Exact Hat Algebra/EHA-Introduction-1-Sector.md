# Lecture Note 1: Exact Hat Algebra in the 1-Sector Eaton–Kortum Model


## 1. Motivation

Suppose we want to answer a question like: *"If the United States imposes a 25% tariff on imports from China, what happens to real wages in every country in the world?"*

To answer this using a structural model like the model in Eaton & Kortum (2002), the traditional approach requires the following steps:

1. Specify a model of trade (technology, preferences, trade costs).
2. Estimate or calibrate every structural parameter — including bilateral trade costs $d_{ni}$ between every pair of countries, which are notoriously difficult to observe directly.
3. Change the value of one or more structural parameters (e.g., the bilateral trade cost between exporter $i$ and importer $j$), solve the "new" model in levels, and compare the new equilibrium to the old one.

Step 2 is often the bottleneck: trade costs are a black box combining tariffs, transport costs, language barriers, cultural differences, and information frictions, and there rarely are good direct measures of them.

**Exact hat algebra**, developed by Dekle, Eaton, and Kortum (2007, 2008) building on Eaton and Kortum (2002), offers a shortcut. The key insight is the following.

If we only care about *changes* relative to an observed baseline equilibrium, many unobservable structural parameters cancel out algebraically. We can characterize the counterfactual equilibrium (relative to the baseline equilibrium) using only:

 1. data on the baseline equilibrium (trade shares, expenditure)
 2. a small number of elasticities, and
 3. the size of the shock we want to study.

This is "exact" because the resulting system of equations is not a linear approximation around the initial equilibrium. Rather, it is an exact rewriting of the fully nonlinear model in terms of relative changes in gross terms (more on that later).

## 2. The "hat" Notation

For any variable $x$ that takes a baseline value and a counterfactual value $x'$, define its **proportional change**:

$$\hat{x} \equiv \frac{x'}{x}$$

So $\hat{x} = 1.10$ means $x$ rises by 10%; $\hat{x} = 0.95$ means it falls by 5%. The goal in a hat-algebra derivation is to write the model's optimality and equilibrium conditions as relationships between hats (i.e., gross changes) and to check which "level" variables or parameters drop out in the process.

Ideally, we would like level objects that are hard to measure in the data to drop out when we derive the optimality and equilibrium conditions. In the trade literature, trade costs are very hard to measure and it would be ideal if there was a way to characterize how an economy responds to changes in trade costs without needing to know what the initial trade costs (in levels) are.

## 3. The Eaton–Kortum (2002) Environment

**Countries.** There are $N$ countries. Let $i$ index an exporting/origin country and $n$ an importing/destination country.

**Technology.** Every country $i$ can produce a continuum of goods. For each good, country $i$ draws a productivity level $z$ from a Fréchet distribution with CDF:

$$F_i(z) = \exp\left(-T_i z^{-\theta}\right),$$

where

- $T_i > 0$ is the scale parameter of the distribution and captures country $i$'s **aggregate productivity**: a higher $T_i$ shifts the entire Fréchet distribution up so that high productivity draws are more likely.
- $\theta > 0$ is the shape parameter of the distribution and governs the dispersion (or variability) of draws from the productivity distribution: a *low* $\theta$ means efficiency is highly variable across goods (strong comparative advantage forces), while a *high* $\theta$ means efficiencies are similar across goods (comparative advantage matters less). We will see later that $\theta$ is closely related to the so-called *trade elasticity* (i.e., by how many percentage points does the value of imports / exports change in response to a one-percentage point change in their price).

**Costs.** Producing a unit of a good in country $i$ costs $c_i$. For example, if labor is the only factor of production and the production technology is linear in labor (and therefore exhibits constant returns to scale, which is a "natural" starting point in macroeconomics), $c_i = w_i$, i.e., labor costs (wages) are the only costs of production.

**Trade costs.** Shipping a good from $i$ to $n$ incurs an *iceberg trade cost*: $d_{ni} \geq 1$ units must be shipped for 1 unit to arrive, with $d_{nn} = 1$ (no cost to ship domestically). The latter can be thought of as a normalization is not a crucial assumption. The cost (and eventually, the price) of a good in destination $n$ shipped from $i$ (to $n$) is therefore $c_i d_{ni}$ divided by the good's efficiency draw.

**Market structure.** Markets are perfectly competitive. Buyers in country $n$ purchase a particular good or variety from the lowest-cost producer (taking into account the iceberg trade cost), labeled $j$:

$$ p_{nj} = \min_{i \in N} \left\{ \frac{d_{ni} w_{ni}}{z_{ni} T_i} \right\}$$

Perfect competition implies that firm generate zero-profit and the price in destination $n$ equals the marginal cost of producing the good in $i$ adjusted for the iceberg cost of shipping from $n$ to $i$.

## 4. Two key Equilibrium Objects

The choice of a Fréchet distribution in the original Eaton–Kortum (2002) was not accidental. The distribution has some useful properties (which it shares with other extreme-value distributions) and they largely account for the "elegant" results in the paper. In particular, they deliver tractable formulae for (a) the bilateral trade shares and (b) the price index.

### (a) Bilateral trade shares

The share of country $n$'s total expenditure that is sourced from country $i$ is:

$$\pi_{ni} = \frac{T_i (c_i d_{ni})^{-\theta}}{\Phi_n}, \qquad \Phi_n \equiv \sum_{k=1}^N T_k (c_k d_{nk})^{-\theta}$$

Intuitively, $i$ captures a larger share of $n$'s spending if it is technologically more advanced ($T_i$ high), has low input costs ($c_i$ low), or has a low bilateral trade cost $d_{ni}$ relative to every other potential supplier $k$, which is exactly what the expression $\Phi_n$ "summarizes".

### (b) The price index

Country $n$'s exact price index for the continuum of goods is:

$$P_n = A \cdot \Phi_n^{-1/\theta}$$

where $A$ is a constant depending only on $\theta$ (via a Gamma-function term) and is identical across countries.

**The problem:** $\pi_{ni}$ and $P_n$ depend on the levels of $T_i$, $c_i$, and $d_{ni}$. The trade costs, in particular, are essentially unobservable at the bilateral level.

*Note: $T_i$ and $d_{ni}$ are exogenous parameters of the model and are typically inferred from data. $c_i$ (or $w_i$) is an endogenous variable and we solve for the equilibrium value (for each $i$) as a function of all the exogenous parameters. Since trade costs, in particular, are difficult to measure, one can see that solving for the levels of these variables is challenging.*

## 5. Deriving the Hat-Algebra Equation for Trade Shares

Suppose that some fundamentals of the economy change. For instance, technology $(T_i \to T_i')$, costs $(c_i \to c_i')$, or trade costs $(d_{ni} \to d_{ni}')$ rise or fall.

Next, write the *counterfactual* trade share using the formula from 4.(a):

$$\pi_{ni}' = \frac{T_i' (c_i' d_{ni}')^{-\theta}}{\Phi_n'}.$$

Now divide through by the initial share $\pi_{ni}$:

$$\hat{\pi}_{ni} = \frac{\pi_{ni}'}{\pi_{ni}} = \frac{T_i'(c_i' d_{ni}')^{-\theta}/\Phi_n'}{T_i(c_i d_{ni})^{-\theta}/\Phi_n} = \hat{T}_i (\hat{c}_i \hat{d}_{ni})^{-\theta} \cdot \frac{\Phi_n}{\Phi_n'}.$$

We still need to express $\Phi_n'/\Phi_n$ without reintroducing levels. Here is the key algebraic trick. From the definition of $\pi_{ni}$, we know:

$$T_i (c_i d_{ni})^{-\theta} = \pi_{ni}\, \Phi_n.$$

So we can rewrite $\Phi_n'$ as:

$$\Phi_n' = \sum_k T_k' (c_k' d_{nk}')^{-\theta} = \sum_k \hat{T}_k (\hat{c}_k \hat{d}_{nk})^{-\theta} \cdot T_k(c_k d_{nk})^{-\theta} = \sum_k \hat{T}_k (\hat{c}_k \hat{d}_{nk})^{-\theta} \cdot \pi_{nk} \Phi_n.$$

Dividing both sides by $\Phi_n$:

$$\frac{\Phi_n'}{\Phi_n} = \sum_k \pi_{nk}\, \hat{T}_k (\hat{c}_k \hat{d}_{nk})^{-\theta}.$$

What did just happen? The right-hand side is expressed entirely in terms of $\pi_{nk}$ (an observable baseline data object) and the hats of the shocked variables. The unobservable levels $T_k$, $c_k$, $d_{nk}$ have vanished and only their *gross changes* remain.

Substituting back, we obtain the central result of exact hat algebra for the EK model:

$$\hat{\pi}_{ni} = \frac{\hat{T}_i (\hat{c}_i \hat{d}_{ni})^{-\theta}}{\displaystyle\sum_{k=1}^N \pi_{nk}\, \hat{T}_k (\hat{c}_k \hat{d}_{nk})^{-\theta}}$$

This equation lets us compute the new trade share pattern using only:

1.  the *baseline* trade shares $\pi_{nk}$, which we observe directly in customs/trade data,
2.  the trade elasticity $\theta$, typically estimated in a separate exercise, and 
3.  the hypothesized shocks $\hat{T}_k, \hat{c}_k, \hat{d}_{nk}$ (e.g., a tariff increase enters as a $\hat{d}_{ni} > 1$ on that route).

The associated change in the price index follows immediately:

$$\hat{P}_n = \left[\sum_k \pi_{nk} \hat{T}_k (\hat{c}_k \hat{d}_{nk})^{-\theta}\right]^{-1/\theta}$$

This is called "exact" because we derived $\hat{\pi}_{ni}$ without ever linearizing or approximating the equations around some initial equilibrium or steady state. The equation holds for arbitrarily large shocks, not just small ones.

## 6. Closing the Model (General Equilibrium)

The trade share equation alone doesn't pin down the equilibrium, because $\hat{c}_i = \hat{w}_i$ (wage changes) are themselves endogenous. Wages and therefore income and expenditure must adjust so that goods markets clear: the sum of all trade balances has to equal zero.

**Income and expenditure.** With labor as the sole factor, country $i$'s income is $Y_i = w_i L_i$. Let $D_n$ denote country $n$'s trade deficit (exogenous, for now), so total expenditure is:

$$X_n = Y_n + D_n$$

**Market clearing.** Total sales by country $i$ across all destinations must equal its income:

$$Y_i = \sum_{n=1}^N \pi_{ni} X_n$$

Writing this condition for the *counterfactual* equilibrium, using $\pi_{ni}' = \hat{\pi}_{ni}\pi_{ni}$ and $Y_i' = \hat{w}_i Y_i$:

$$\hat{w}_i\, Y_i = \sum_{n=1}^N \pi_{ni}\, \hat{\pi}_{ni}\, \left(\hat{w}_n Y_n + D_n\right)$$

This is a system of $N$ equations in the $N$ unknown wage changes $\{\hat{w}_i\}$. Bear in mind that $\hat{\pi}_{ni}$ on the right-hand side is *itself* a function of all the $\hat{w}_i$ through the equation in Section 5 (since $\hat{c}_i = \hat{w}_i$).

**Solving the system of equations.** This system is nonlinear and generally has no closed-form solution, but it is straightforward to solve numerically:

1. Guess a vector of wage changes $\{\hat{w}_i^{(0)}\}$, where the $(0)$ superscript indicates that this is a guess.
2. Use these to compute implied trade share changes $\hat{\pi}_{ni}$ from Section 5.
3. Plug into the market-clearing condition to get an updated income identity, and back out updated wage changes $\{\hat{w}_i^{(1)}\}$.
4. Update $\{\hat{w}_i^{(0)}\} = \{\hat{w}_i^{(1)}\}$ and iterate over guesses and their updates until the wage vector converges.

This iterative numerical procedure applied to the equations **is** exact hat algebra in practice. Note again what data this requires: only the *baseline* trade share matrix $\{\pi_{ni}\}$ (observable), baseline income/expenditure levels, the elasticity $\theta$, and the exogenous shock. At no point do we need to know a single bilateral trade cost $d_{ni}$ or aggregate productivity $T_n$ in levels.

## 7. A Sufficient Statistic for Welfare

One of the most celebrated results building on this framework — which is due to a seminal paper by Arkolakis, Costinot, and Rodríguez-Clare (2012), often abbreviated **ACR** — is that in this class of models, the welfare consequence of a shock for country $n$ can be computed from just two numbers:

$$\hat{W}_n = \left(\hat{\pi}_{nn}\right)^{-1/\theta},$$

where $\hat{W}_n$ is the change in real income (welfare) and $\hat{\pi}_{nn}$ is the change in the **home trade share**, the share of country $n$'s expenditure spent on its own domestically produced goods.

This is a remarkable simplification: to evaluate the welfare impact of a tariff change, a productivity shock abroad, or a transport-cost improvement, we do not need to solve for the entire multi-country general equilibrium in detail. We only need to know (i) how much of country $n$'s spending shifts toward or away from domestic goods, and (ii) the trade elasticity $\theta$. The intuition is that the home share is a sufficient statistic for the gains from trade: the less a country relies on imports, the smaller the welfare loss from being cut off from the rest of the world (and symmetrically for gains from *increased* openness).

Clearly, the ACR result depends on the trade elasticity, which we have treated as an exogenous parameter for the purposes of exposition. In practice, one must estimate the trade elasticity and this is a challenging empirical problem. This lecture note sidesteps this separate discussion entirely.

## 8. Summary

| Object | Role |
|---|---|
| $T_i, c_i, d_{ni}$ | Unobservable structural levels — never estimated directly |
| $\pi_{ni}$ (baseline) | Observable data — bilateral trade shares |
| $\theta$ | Single elasticity, estimated externally |
| $\hat{T}_i, \hat{c}_i, \hat{d}_{ni}$ | The counterfactual shock we impose |
| $\hat{\pi}_{ni}, \hat{w}_i, \hat{P}_n, \hat{W}_n$ | Solved for using exact hat algebra |

The general logic is: **write the model in ratios, watch unobservable levels cancel, solve the remaining system using only baseline data plus a few elasticities**.

It actually extends well beyond this simple one-sector Eaton–Kortum model (although the algebra gets messier when we add more elements). It underlies modern quantitative trade models with multiple sectors, intermediate inputs and input-output linkages, and richer market structures (e.g., Melitz-style monopolistic competition), as in Dekle, Eaton, and Kortum's later work and Caliendo and Parro (2015), to name just a few.

## Appendix A: Household Preferences and the Irrelevance of $\sigma$

Sections 3–7 never mentioned how households aggregate the continuum of varieties into utility. This is an important detail and this appendix shows how the aggregation "drops out", which is one reason why the model is as tractable as it is.

### A.1. The standard assumption

Within each country, the representative consumer has **CES preferences** over the continuum of varieties $u \in [0,1]$ available in the (single) good:

$$U_n = \left[\int_0^1 q_n(u)^{\frac{\sigma-1}{\sigma}}\, du\right]^{\frac{\sigma}{\sigma-1}},$$

where $q_n(u)$ is consumption of variety $u$ in country $n$, and $\sigma > 1$ is the **elasticity of substitution** across varieties.

### A.2. $\sigma$ drops out

Given CES preferences and competitive pricing (each variety $u$ is supplied by whichever country offers the lowest price, as in Section 3), the exact CES price index over this continuum is:

$$P_n = \left[\int_0^1 p_n(u)^{1-\sigma}\, du\right]^{\frac{1}{1-\sigma}}$$

Because the price $p_n(u)$ of each variety is itself the minimum over $N$ Fréchet-distributed cost draws, evaluating this integral requires a change of variables into the distribution of minimum prices. Carrying out that calculation (a standard result from extreme value theory, done in full in Eaton and Kortum (2002), Appendix) yields:

$$P_n = A \cdot \Phi_n^{-1/\theta}, \qquad A = \left[\Gamma\left(\frac{\theta+1-\sigma}{\theta}\right)\right]^{\frac{1}{1-\sigma}},$$

which is exactly the price index stated in Section 4(b). The key thing to notice: **$\sigma$ appears only inside the constant $A$.** The exponent on $\Phi_n$ (the object that actually varies with technology and trade costs, and hence the object that matters for every counterfactual) is $-1/\theta$, with no $\sigma$ in sight. 

The same is true of the trade share formula $\pi_{ni}$. It is derived purely from the *probability* that country $i$ offers the lowest price to country $n$ for a given variety, which depends only on the Fréchet parameters $T_i, \theta$ and the costs $c_i, d_{ni}$. The elasticity of substitution never enters this probability calculation at all.

**Intuition.** The CES aggregator's job is to convert a whole distribution of variety-level prices into a single scalar cost-of-living number. $\sigma$ governs *how substitutable* those varieties are, which determines the weight of each variety as a function of its price. But *which country supplies which variety*, and *how the whole price distribution shifts* when $T_i$ or $d_{ni}$ changes, is governed entirely by the Fréchet extreme-value distribution and its shape parameter $\theta$. Put differently, $\sigma$ affects the *level* of the price index (through $A$) but not its *sensitivity to shocks* (through $\Phi_n$).

### A.3. Why this is convenient for hat algebra?

This is not just a curiosity. It is exactly why $\sigma$ never appeared anywhere in Sections 5–7. Since $A$ is a constant (a function of $\theta$ and $\sigma$ alone, not of any variable that changes across the baseline and counterfactual), it cancels automatically when we take the hat of the price index:

$$\hat{P}_n = \frac{P_n'}{P_n} = \frac{A \cdot (\Phi_n')^{-1/\theta}}{A \cdot \Phi_n^{-1/\theta}} = \left(\frac{\Phi_n'}{\Phi_n}\right)^{-1/\theta}$$

The constant $A$ and therefore any dependence on $\sigma$ drops out identically, regardless of what value $\sigma$ takes. This means we never needed to estimate or calibrate $\sigma$ to perform any of the counterfactual exercises in this handout. Contrast this with Armington or Krugman-style models, where $\sigma$ is *the* central elasticity governing the gains from trade, and getting it right (or wrong) directly determines the magnitude of counterfactual welfare changes. In the Eaton–Kortum framework, that role is instead played entirely by $\theta$.

### A.4. An important parameter restriction

For $P_n$ (and hence $U_n$) to be finite, the model requires the parameter restriction:

$$\theta > \sigma - 1.$$

This condition ensures the relevant integral defining the price index converges. Intuitively, $\theta$ governs how much "extreme" low-price draws are possible across the continuum of varieties; if there is too little productivity dispersion ($\theta$ too large is fine, but conceptually one needs enough tail thinness relative to how aggressively CES rewards the cheapest varieties as $\sigma$ rises) the integral can diverge. In practice this restriction is rarely binding in applied work, since estimated values of $\theta$ (typically in the range of 4–10) comfortably satisfy it for standard values of $\sigma$, but it is worth stating as a formal condition for the model to be well-defined.

Since $\sigma$ drops out of the exact hat algebra, the lecture notes that cover richer versions of this environment (multiple sectors, input-output linkages,...) will be silent on the parameter's role and will not explicitly solve the household's utility maximization problem.