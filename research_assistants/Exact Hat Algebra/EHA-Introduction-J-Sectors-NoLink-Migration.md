# Lecture Note 4: Exact Hat Algebra in a Dynamic Spatial Model with Migration

In this lecture note we drop the input-output linkages (which had been introduced in Lecture Note 3) but we add a new feature: while workers have been able to move at no cost between sectors (within a country) so far, reallocation now is subject to moving costs. Notice that this is a substantial departure from the economy were full mobility implied that every worker earned the same wage within a country. Introducing moving costs implies that workers in different sectors will be paid sector-specific wages.

The introduction of labor market frictions also offers an opportunity to add a notion of geography to the economy. In addition to switching from one sector to another, workers can move from one geographic location (typically a state or a so-called "commuting zone") to another. Mechanically, switching industries and moving in space are subject to the same type of friction and we will model the decision jointly: at time $t$, a worker in location $n$ and sector $j$ can decide to switch/move to location $i$ and sector $k$, including $i=n$ and/or $j=k$, subject to a cost $\tau^{nj,ik}$ at time $t+1$. Importantly, a worker's location $(n,j)$ at time $t$ is included in the *state space* of the economy. In other words, the worker "wakes up" in $(n,j)$ at the beginning of period $t$ and cannot move to a different location within that period. She may prefer to be in a different location, but cannot leave $n,j$ until the end of period $t$.

 In a nutshell, this lecture note describes a simplified version of the economy in Caliendo, Dvorkin, and Parro's "Trade and Labor Market Dynamics" paper (2019, *Econometrica*).

## 1. Motivation

Every model in Lecture Notes 1–3 shared one feature: labor reallocates instantaneously and costlessly across sectors (and, implicitly, locations) within a period. When the economy is hit by a trade shock, wages adjust and the economy jumps immediately to a new equilibrium. There are no intersting dynamics in this class of models. The economy "jumps" from one steady state to another. This is a useful simplification for studying long-run outcomes, but it is not a useful tool to understand how an economy transitions from one steady state to another. If a trade shock displaces workers from the steel sector, how quickly — and at what cost — do they find new jobs, in what sectors, and in what places?

Answering this requires two new ingredients: (i) an explicit **state variable**, the distribution of workers across location-sector pairs at each point in time, and (ii) a model of **costly migration** that ultimately characterizes how that distribution evolves over time. Workers who could move at no cost would jump to wherever wages are currently highest, exactly as in the static model. Workers facing moving costs and future uncertainty must instead weigh a costly move today against the *discounted expected value* of the destination, which is exactly the kind of forward-looking, dynamic decision problem that requires new tools.

**Relation to the previous notes.** We follow the notation of Lecture Note 2 for the production side, with two simplifications relative to the general model in Caliendo, Dvorkin, and Parro (2019):

- **No input-output linkages**, as in Lecture Note 2: in the notation of the original paper, this implies $\gamma^{nj} = 1$ and $\gamma^{nj,nk} = 0$ for every location $n$ and sectors $j$ and $k$.
- **No local trade imbalances**: in the notation of the original paper, we set $\xi^n = 0$ for every location $n$. Production does not require local structures, which implies that every location's expenditure equals its income in every period. There is no local (within-country) analogue of the deficit term $D_n$ from Lecture Notes 1–3.

What is genuinely new is the *dynamic migration block*, which we build up in Sections 2 and 4, and the extension of exact hat algebra to a dynamic setting (Section 5).

## 2. The Environment: Locations, Sectors, and the State of the Economy

**Locations and sectors.** There are $N$ locations, indexed $i$ or $n$, and $J$ sectors, indexed $j$ or $k$, exactly as in Lecture Notes 1–3.

Note that a location $n$ can be a state or communiting zone *within* a country or a whole country. We only care about the distinction to the extent that labor cannot move across international borders. If locations $(n,\cdot)$ and $(i,\cdot)$ are in two different countries, we capture that by setting $\tau^{n\cdot,i\cdot} \rightarrow +\infty$. In any numerical application, we set the moving cost to an arbitrarily large number to prevent cross-border migration.

**Time and the state of the economy.** Time is discrete and indexed by $t$. A worker's idiosyncratic state at the beginning of period $t$ is the location-sector pair $(n,j)$ they currently occupy. Let $L_t^{nj} \geq 0$ denote the measure of workers in state $(n,j)$ at the start of period $t$. The world population is exogenous and denoted $\bar{L}_t$. The distribution of workers across locations is such that

$$\sum_{n=1}^N \sum_{j=1}^J L_t^{nj} = \bar{L}, \quad \text{for every } t.$$

The full matrix $\{L_t^{nj}\}_{n\in N,j \in J}$ describes the (endogenous) aggregate state of the economy at time $t$. This state has a Markov property in the sense that $\{L_t^{nj}\}$ summarizes the economy's complete history that is relevant for decision making at time $t$.

**Technology.** As in Lecture Note 2 with no input-output linkages, the firm producing variety $\omega$ in sector $j$, location $n$, at time $t$ draws productivity $z_{t}^{nj}(\omega)$ from a Fréchet distribution $F_n^j(z) = \exp(-T_n^j z^{-\theta^j})$ and produces variety $\omega$ using labor:

$$y_{t}^{nj}(\omega) = z_{t}^{nj}(\omega)\, \ell_{t}^{nj}(\omega)$$

The key difference from Lecture Note 2 is that labor supplied to sector $j$ in location $n$ at time $t$ is not freely reallocated to or from other location-sector pairs within the period. Labor supply is locally inelastic and given by $L_t^{nj}$. The cost of production is therefore the location-and-sector-specific wage:

$$c_{t}^{nj} = w_{t}^{nj}$$

Unlike in Lecture Note 2, there is no reason for $w_{t}^{nj}$ to be the same across sectors within a location $n$ or to be the same across locations within a sector $j$. Since workers cannot costlessly reallocate within the period, nothing equalizes location-sector specific wages at time $t$. Wage equalization occurs gradually, by way of migration, across periods.

**Trade costs.** International and intranational trade is subject to iceberg costs $d_t^{nj,ij} \geq 1$. Differences in cross-border trade costs are captured by higher iceberg costs whenever a good or service crosses an international border.

**Market clearing.** Since we assume $\xi^n = 0$ for all $n$, total expenditure on output from sector $j$ in location $n$ equals final demand in location $n$:

$$X_t^{nj} = \alpha^j\sum_{k=1}^J w_t^{nk} L_t^{nk}.$$

The right-hand side of this expression reflects the assumption that households in location $(n,j)$ have Cobb-Douglas preferences over output produced by the $J$ sectors of the economy:

$$C_t^{nj} = \prod_{k=1}^J (c_t^{nj,k})^{\alpha^k}.$$

Notice that there is no (trade) deficit term $D_n$ in the market clearing condition. The original Caliendo et al. (2019) paper features local trade imbalances that are micro-founded with local non-traded factor inputs (so-called structures) with a clever but somewhat complicated ownership system. In the interest of simplicity, we abstract from it here.

## 3. Static (Within-Period) Trade

Given the state $\{L_t^{nj}\}$ at date $t$, goods markets clear within the period exactly as in the static models of Lecture Notes 1–2, with time subscripts added and wages now indexed by sector as well as location.

**Trade shares and price indices.** Before we review trade shares and prices it is worth recalling what exactly is traded in this economy. Recall from the second lecture note that in each location $n$ and sector $j$, a local sectoral composite good is produced by "combining" the lowest-cost varieties that are produced locally or are imported from other locations $i \neq n$:

$$ Q_t^{nj} = \left( \int_0^1 {q}_t^{nj}(\omega)^{\frac{\sigma-1}{\sigma}} d\omega \right)^{\frac{\sigma}{\sigma-1}},$$

The quantity ${q}_t^{nj}(\omega)$ depends on the price and that, in turn, depends on the productivity of the supplier, the local labor cost in the supplier's home market, and the iceberg trade cost between the origin $i$ and the destination $n$. Here, the Eaton-Kortum "machinery" takes advantage of the probabilistic nature of production and hence trade and it is worth revisiting it.

Recall that the productivity draw of a variety-$\omega$ producer is i.i.d. across location and time. This implies that the vector of productivities across all locations for this variety consists of $N$ independent draws from the same Fréchet distribution and it can be characterized by:

$$\phi^j(z^j) = \exp\left\{ -\sum_{n=1}^N (z^{nj})^{-\theta^j} \right\}.$$

THERE IS SOME ISSUE WITH NOTATION. I DON'T KNOW WHERE $T$ IS COMING FROM AND HOW IT IS DERIVED FROM $A$, IF AT ALL.

$$\pi_t^{nj,ij} = \frac{T_t^{ij} \left(w_{t}^{ij}\, d_t^{nj,ij}\right)^{-\theta^j}}{\Phi_t^{nj}}, \qquad \Phi_t^{nj} = \sum_{m=1}^N T_t^{mj} \left(w_t^{mj}\, d_t^{nj,mj}\right)^{-\theta^j}, \qquad P_{n,t}^j = A^j \left(\Phi_t^{mj}\right)^{-1/\theta^j}$$

The aggregate price index at location $n$ is, as before, $P_{n,t} = \prod_{j=1}^J \left(P_{n,t}^j\right)^{\alpha_n^j}$.

**The hat-algebra derivation carries over unchanged**, exactly as in Lecture Notes 1–2 (recall that the argument doesn't depend on whether $c_t^{nj}$ has a time subscript):

$$\hat{\pi}_T^{nj,ij} = \frac{\hat{T}_t^{ij} \left(\hat{w}_{t}^{ij}\, \hat{d}_t^{nj,ij}\right)^{-\theta^j}}{\displaystyle\sum_{m=1}^N  \hat{T}_t^{mj} \left(\hat{w}_{t}^{mj}\, \hat{d}_t^{nj,mj}\right)^{-\theta^j}}$$

**Market clearing.** Because labor cannot reallocate across sectors within the period, the labor market clears cell by cell, not location-wide. Sector $j$ and location $i$'s revenue must exactly cover the wage bill paid to the $L_t^{ij}$ workers currently in that cell:

$$w_t^{ij}\, L_t^{ij} = R_t^{ij} \equiv \sum_{n=1}^N \pi_t^{nj,ij}\, X_t^{nj}.$$

(Compare Lecture Note 2's aggregated condition $w_iL_i = \sum_j R_i^j$, which pooled revenue *across* sectors before equating it to the wage bill. Due to the contemporaneous immobility of labor this is no longer the case since a dollar of revenue in sector $j$ cannot pay a worker located in  sector $k \neq j$.)

In changes, taking $L_t^{nj}$ as given (it is, after all, an element of the aggregate state of the economy):

$$\hat{w}_t^{nj}\, \hat{L}_t^{nj}\, w_t^{nj}\, L_t^{nj} = \sum_{i=1}^N \pi_t^{ij,nj}\, X_t^{ij}, \quad\textrm{where} \quad X_t^{nj} = \alpha^j \left( \sum_{k=1}^J \hat{w}_t^{nk} \, \hat{L}_t^{nk} \, w_t^{nk} \,L_t^{nk} \right)$$

For a given labor allocation $\{L_t^{nj} \}$, this is a system of $N \times J$ equations in the $N \times J$ unknown wage changes $\{\hat w_t^{nj}\}$, solved by the same guess-and-iterate procedure as in Lecture Notes 1–3. This static block is the "temporary equilibrium" (in Caliendo et al.'s parlance) we will have to solve for in each period when we iterate the solution algorithm in the dynamic optimization problem.

## 4. Worker Migration: Preferences, Moving Costs, and the Dynamic Discrete-Choice Problem

**Flow utility.** A worker in state $(n,j)$ at time $t$ enjoys flow (log) utility from consuming their real wage, scaled by a location-sector amenity $b^{n,j}$ (a fixed, unobservable taste shifter — think of it as capturing climate, local public goods, or anything else that makes a location-sector pair more or less pleasant to live in, beyond its wage):

$$u_{n,t}^j = b^{n,j}\, \frac{w_{n,t}^j}{P_{n,t}}$$

**Moving costs.** Moving from state $(n,j)$ to state $(n',j')$ entails a utility cost $\kappa^{nj,n'j'} \geq 0$, with $\kappa^{nj,nj} = 0$ (staying is free). These costs are additive in utils, structural, and time-invariant.

**Idiosyncratic preference shocks.** At the end of each period, every worker draws an idiosyncratic preference shock $\varepsilon_t(n',j')$ for *every* possible destination state $(n',j') \in \{1,\dots,N\} \times \{1,\dots,J\}$, i.i.d. across workers, time, and destinations, from a standard Type-I Extreme Value (Gumbel) distribution. Let $\nu > 0$ be a dispersion (scale) parameter: a worker's realized idiosyncratic utility from choosing $(n',j')$ is $\nu\,\varepsilon_t(n',j')$. A low $\nu$ means preferences are close to homogeneous (workers respond very sharply to value differences across states); a high $\nu$ means idiosyncratic taste heterogeneity dominates and migration flows respond only sluggishly to economic incentives.

**The worker's dynamic problem.** Let $\beta \in (0,1)$ be the discount factor. A worker in state $(n,j)$ at time $t$ solves:

$$V_t^{n,j} = \ln u_{n,t}^j + \mathbb{E}_\varepsilon\left[\max_{n' \in \{1,\dots,N\},\; j' \in \{1,\dots,J\}} \left\{-\kappa^{nj,n'j'} + \beta\, V_{t+1}^{n'j'} + \nu\, \varepsilon_t(n',j')\right\}\right]$$

That is: enjoy this period's flow utility in the current state, then choose next period's state to maximize the (discounted) continuation value net of the moving cost, plus an idiosyncratic taste draw.

**Closed-form solution via the Gumbel distribution.** This is exactly the setting where the Fréchet distribution's cousin, the Gumbel (Type-I extreme value) distribution, delivers the same kind of tractability that the Fréchet delivered for the static trade block. A standard result in discrete-choice theory gives a closed form for the expectation of the max:

$$V_t^{n,j} = \ln u_{n,t}^j + \nu\,\gamma_E + \nu \ln\left(\sum_{n'=1}^N\sum_{j'=1}^J \exp\left(\frac{-\kappa^{nj,n'j'} + \beta V_{t+1}^{n'j'}}{\nu}\right)\right)$$

where $\gamma_E \approx 0.5772$ is the Euler–Mascheroni constant, and the associated **migration share** — the probability (equivalently, the population share) that a worker in state $(n,j)$ at $t$ moves to state $(n',j')$ at $t+1$ — has the familiar logit form:

$$\mu_t^{nj,n'j'} = \frac{\exp\left(\dfrac{-\kappa^{nj,n'j'} + \beta V_{t+1}^{n'j'}}{\nu}\right)}{\displaystyle\sum_{n''=1}^N\sum_{j''=1}^J \exp\left(\dfrac{-\kappa^{nj,n''j''} + \beta V_{t+1}^{n''j''}}{\nu}\right)}$$

**Law of motion for the state.** Aggregating individual choices, the distribution of workers evolves as:

$$L_{t+1}^{n',j'} = \sum_{n=1}^N \sum_{j=1}^J \mu_t^{nj,n'j'}\, L_t^{n,j}$$

This is a Markov chain on the state space $\{1,\dots,N\}\times\{1,\dots,J\}$, but with **transition probabilities that are themselves equilibrium objects** — they depend on the entire future path of value functions, which depend on future wages and prices, which depend on the future labor distribution. Solving this model means finding a whole *path* of $\{L_t^{n,j}\}$, $\{w_{n,t}^j\}$, and $\{V_t^{n,j}\}$ that are mutually consistent, not a single cross-sectional equilibrium.

## 5. Exact Hat Algebra in the Dynamic Model

We now extend the hat-algebra logic of Lecture Notes 1–3 to this dynamic environment. As before, the goal is to characterize the counterfactual **path** relative to a baseline path using only observable baseline data, elasticities, and the shock — without ever needing to know the levels of $T_i^j$, $b^{n,j}$, or (new to this note) the moving costs $\kappa^{nj,n'j'}$.

**Ratios don't work for value functions — use differences instead.** $V_t^{n,j}$ is measured in utils (it is a log-additive present value), not in a unit where a ratio $V_t^{n,j\prime}/V_t^{n,j}$ has any natural interpretation. The right analogue of "hat" for an object already expressed in logs is a **level difference**. Define:

$$\Delta V_t^{n,j} \equiv V_t^{n,j\prime} - V_t^{n,j}$$

the (log) change in the continuation value of being in state $(n,j)$ at time $t$, comparing the counterfactual path to the baseline path.

**Deriving the recursion.** Write the Gumbel closed-form solution at the counterfactual path and subtract the baseline version. The moving costs $\kappa^{nj,n'j'}$ and the Euler constant term are identical across baseline and counterfactual (they are structural and unaffected by the shock), so they cancel directly in the subtraction. What is left, after factoring out the baseline normalizing constant exactly as in the static hat-algebra derivations of Lecture Notes 1–3 (multiply and divide by the baseline choice probabilities $\mu_t^{nj,n'j'}$), is:

$$\boxed{\Delta V_t^{n,j} = \Delta u_{n,t}^j + \nu \ln\left(\sum_{n'=1}^N\sum_{j'=1}^J \mu_t^{nj,n'j'}\, \exp\left(\frac{\beta\, \Delta V_{t+1}^{n'j'}}{\nu}\right)\right)}$$

where $\Delta u_{n,t}^j \equiv \ln \hat u_{n,t}^j = \ln \hat w_{n,t}^j - \ln \hat P_{n,t}$ is the change in log real income in state $(n,j)$ at $t$ — an object we already know how to compute from the static trade block of Section 3. (Note that the location-sector amenity $b^{n,j}$, structural and time-invariant, cancels out of $\Delta u_{n,t}^j$ for exactly the same reason $T_i^j$ cancelled out of $\hat\pi_{ni}$ in Lecture Note 1: it appears identically in the numerator and "denominator" of the comparison and never varies across the baseline/counterfactual pair.)

**What just happened, and why it matters.** This equation expresses the change in continuation value at $(n,j,t)$ purely in terms of: (i) the change in this period's real income, which the static trade block hands us; (ii) **baseline** migration shares $\mu_t^{nj,n'j'}$; and (iii) *next period's* value-function changes $\Delta V_{t+1}^{n'j'}$. The unobservable moving-cost matrix $\kappa^{nj,n'j'}$ — arguably the hardest object in this entire model to measure directly, since it requires knowing the utility cost of every possible move for every possible worker — never needs to be estimated in levels. In its place, we need only the **baseline migration flow shares** $\mu_t^{nj,n'j'}$, which (unlike $\kappa$) are directly observable in worker-level panel data (e.g., social security or matched employer-employee records that track workers' location and sector over time). This is the dynamic analogue of Lecture Note 1's insight that baseline trade shares are sufficient, without ever needing bilateral trade costs in levels.

**Migration shares in changes.** Dividing the counterfactual choice probability by the baseline one (the same manipulation used to derive $\hat\pi_{ni}$ in Lecture Note 1) gives:

$$\hat{\mu}_t^{nj,n'j'} = \frac{\exp\left(\beta\, \Delta V_{t+1}^{n'j'}/\nu\right)}{\displaystyle\sum_{n''=1}^N\sum_{j''=1}^J \mu_t^{nj,n''j''}\, \exp\left(\beta\, \Delta V_{t+1}^{n''j''}/\nu\right)}$$

which, together with the law of motion in Section 4, gives the counterfactual labor distribution in changes:

$$L_{t+1}^{n',j'\prime} = \sum_{n=1}^N \sum_{j=1}^J \mu_t^{nj,n'j'}\, \hat{\mu}_t^{nj,n'j'}\, L_t^{n,j}\, \hat{L}_t^{n,j}$$

**A crucial initial condition.** The state at $t=0$ is predetermined — it is inherited from history and cannot jump in response to a shock announced or realized at $t=0$:

$$\hat{L}_0^{n,j} = 1 \quad \text{for every } (n,j)$$

This is the dynamic analogue of a boundary condition, and it is essential: it is what "anchors" the whole transition path.

## 6. Closing the Model: Solving for a Perfect-Foresight Transition Path

Putting the pieces together, solving this model for a counterfactual (e.g., a permanent change in some $d_{ni}^j$ starting at $t=0$) means finding a path $\{\hat w_{n,t}^j\}_{t=0}^\infty$, $\{\hat L_t^{n,j}\}_{t=0}^\infty$, and $\{\Delta V_t^{n,j}\}_{t=0}^\infty$ that jointly satisfy: the static trade block (Section 3) at every date $t$; the value-function recursion (Section 5) *running backward* from a terminal condition; and the law of motion for the labor distribution (Section 5) *running forward* from the initial condition $\hat L_0^{n,j}=1$.

**Terminal condition.** If the shock is permanent, the economy eventually settles into a new stationary distribution as $t \to \infty$. In practice, one truncates the horizon at some large $T$ and imposes $\Delta V_T^{n,j} \approx 0$ (or, more precisely, solves jointly for the new stationary equilibrium as the terminal condition), on the logic that a sufficiently distant future is unaffected by any residual transition dynamics.

**The nested algorithm.** This is a natural generalization of the guess-and-iterate procedure from Lecture Notes 1–3, now applied over an entire time path rather than a single cross-section:

1. **Guess** a full path of labor-allocation changes $\{\hat L_t^{n,j}\}_{t=0}^T$, consistent with $\hat L_0^{n,j}=1$.
2. **Forward, period by period:** given this guessed path, solve the static trade block of Section 3 at *every* date $t$ to obtain $\{\hat w_{n,t}^j\}$, $\{\hat P_{n,t}\}$, and hence $\{\Delta u_{n,t}^j\}$ for every $t$.
3. **Backward, from $T$ to $0$:** using the sequence $\{\Delta u_{n,t}^j\}$ and the terminal condition $\Delta V_T^{n,j}\approx 0$, solve the recursion in Section 5 backward to obtain $\{\Delta V_t^{n,j}\}_{t=0}^T$.
4. **Forward again, from $0$ to $T$:** use $\{\Delta V_t^{n,j}\}$ to compute migration share changes $\hat\mu_t^{nj,n'j'}$, and iterate the law of motion forward from $\hat L_0^{n,j}=1$ to obtain an *updated* path of labor allocations $\{\hat L_t^{n,j}\}$.
5. **Compare** the updated path to the guess in Step 1. If they differ, update the guess and return to Step 2. Iterate until the whole path converges.

This is exactly the "exact hat algebra" logic of the earlier lecture notes — unobservable structural levels cancel, and the model is solved using only baseline data (now including baseline *migration flow* data, not just baseline trade shares) plus a handful of elasticities ($\theta^j$, $\nu$, $\beta$) and the shock.

## 7. Welfare

A pleasant feature of this framework is that we do not need to construct a separate welfare formula, as we did (with some difficulty, in Lecture Note 3) for the static models. **The value-function change $\Delta V_0^{n,j}$ *is* the welfare metric.** It is, by construction, the (log) present-discounted-value change in utility for a worker who starts the transition in state $(n,j)$ — it already accounts for the entire future path of real wages the worker will experience, correctly weighted by discounting and by the option value of future migration.

This lets us ask questions the static models cannot answer. For instance: two locations might have *identical* long-run (steady-state) real wage changes from a trade shock, yet very different $\Delta V_0^{n,j}$, if workers in one location face higher moving costs to reach growing sectors, or if the transition to the new steady state is slower in one place than the other. The gap between a location's long-run outcome and its $\Delta V_0^{n,j}$ is a direct, quantifiable measure of the welfare cost of *frictional* adjustment — precisely the object that a model with costless, instantaneous reallocation (Lecture Notes 1–3) cannot speak to. An economy-wide welfare summary can be constructed as a population-weighted average of $\Delta V_0^{n,j}$ across all states, using the (predetermined, and therefore uncontroversial) initial distribution $\{L_0^{n,j}\}$ as weights.

## 8. What is the Value Added of Modeling Migration Dynamics?

Lecture Notes 1–3 answer questions of the form "what is the new equilibrium after a shock, once the dust has settled?" This lecture note answers a different, and often more policy-relevant, question: "how does the economy get there, who bears the cost of getting there, and how long does it take?"

The mechanism is entirely due to the state variable $\{L_t^{n,j}\}$ and the costly, forward-looking migration decision built on top of it. Because moving is costly and workers are forward-looking, a shock that hits sector 1 in location $A$ does not instantaneously relocate the affected workers to wherever wages are now highest. Instead, workers gradually migrate — the speed governed by the moving-cost matrix $\kappa^{nj,n'j'}$ and the dispersion parameter $\nu$ — and in the interim, real wages, migration flows, and value functions are all *out of steady state*, exhibiting their own transitional dynamics. This is precisely the kind of pattern documented empirically after major regional trade shocks (workers do not immediately relocate away from adversely affected local labor markets, and some measures of local economic distress persist for years), and matching that pattern quantitatively is the central contribution of the Caliendo, Dvorkin, and Parro (2019) framework relative to the static models of the first three lecture notes.
