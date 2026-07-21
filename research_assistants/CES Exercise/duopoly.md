## Practice Assignment: Bertrand Duopoly with CES Preferences and Linear Production

### Environment

#### Preferences
A representative consumer has CES preferences over two goods:
$$U(q_1, q_2) = \left(\alpha_1 q_1^{\frac{\sigma-1}{\sigma}} + \alpha_2 q_2^{\frac{\sigma-1}{\sigma}}\right)^{\frac{\sigma}{\sigma-1}}, \qquad \sigma > 1,\ \ \alpha_1 + \alpha_2 = 1,\ \ \alpha_1,\alpha_2 > 0$$

The weight $\alpha_i$ associated with good $i$ captures the consumer's relative preference for that good. The restriction $\alpha_1 + \alpha_2 = 1$ is a normalization, without loss of generality.

Total labor supply is exogenous and inelastic at $\bar L$. The household takes the wage rate $w$ as given. The household's total income is denoted $I$. Production does not require capital and, therefore, the household spends its income on consumption, i.e., $I = w\bar L = E$, where $E$ denotes total expenditures.

#### Production
Good $i$ is produced with labor input $\ell_i$ using the following technology:
$$
q_i = A_i \ell_i.
$$
For simplicity, you should assume that the production technology for each good $i$ is owned by an entrepreneur. Her income is denoted $\pi_i$, i.e., the profit of firm $i$. She does not earn any labor income.
#### Market Structure
The labort market is competitive and the household and the firm take the wage rate as given. The labor market has to clear:
$$
\ell_1 + \ell_2 = \bar{L}.
$$

The market for goods is non-competitive and each firm sets a price $p_i$ for good $i$ taking their competitor's price $p_{j \neq i}$ as given. This form of duopoly is called "simultaneous Bertrand competition." Other forms are knows as "Cournot" or "Stackelberg", but we are not going to cover them here.

### Part A: Utility Maximization

1. For given $(p_1,p_2)$, maximize $U(q_1,q_2)$ subject to $p_1 q_1 + p_2 q_2 = E$. Take the first-order conditions and whow that the demand system is characterized by:
$$q_i = \alpha_i^{\sigma}\, p_i^{-\sigma}\, P^{\sigma - 1}\, E, \quad\textrm{where} \quad P \equiv \left(\alpha_1^{\sigma} p_1^{1-\sigma} + \alpha_2^{\sigma} p_2^{1-\sigma}\right)^{\frac{1}{1-\sigma}}.$$
Note: $P$ is the CES price index in Jonathan Dingel's lecture note on the Dixit-Stiglitz algebra. Verify that $p_1q_1+p_2q_2 = E$ and $P = E/U$. It's a bit messy at first, but terms will cancel out in clean ways eventually.

2. Let $s_i \equiv \frac{p_i q_i}{E}$ be the expenditure share of good $i$. Show that:
$$s_i = \frac{\alpha_i^\sigma p_i^{1-\sigma}}{\alpha_1^\sigma p_1^{1-\sigma} + \alpha_2^\sigma p_2^{1-\sigma}}.$$
3. Show that the own-price elasticity $\left(\frac{d \ln q_i}{d \ln p_i} \right)$ is:
$$\varepsilon_i = \sigma - (\sigma-1)s_i.$$

### Part B: Profit Maximization
1. Characterize firm $i$'s profit function $\pi_i(p_i)$.

   Hint: Start with the expression $\pi(\ell_i) = p_i A_i \ell_i - w \ell_i$, use the fact the $q_i \equiv A_i \ell_i$ and your earlier result $q_i = \alpha_i^{\sigma} p_i^{-\sigma} P^{\sigma - 1} w \bar{L}$ to derive $\pi_i(p_i)$.

1. Take the first-order condition of $\pi_i(p_i)$ with respect to $p_i$ and show that

   $p_i = \frac{\sigma - (\sigma-1) s_i}{\sigma - (\sigma-1) s_i-1} \frac{w}{A_i}.$

   Hint: Firm $i$ takes $p_{j \neq i}$ in $P$ as given. However, the firm does take into account that a change in $p_i$ affects the price index $P$.
   
   This "mark-up over marginal cost" formula is at the heart of Bertrand price competition.
   
   Note that the taste weights $\alpha_i$ and $\alpha_j$ do **not** appear directly in the markup formula. They enter only indirectly, through $s_i$.

1. So far, you have characterized the optimal $p_i$ for a given $p_j$. This is a partial equilibrium result. To solve for the general equilibrium, you need a second expression: the optimal $p_j$ for a given $p_i$. It is straightforward to use your answer to the previous question to derive this expression (just be careful with the subscripts).

   Together, this system of two equations in two unkowns, $p_i$ and $p_j$, characterize the general equilibrium of this economy. This problem cannot, in general, be solved analytically (unless we impose some symmetry restrictions on preferences and productivities). In the final part of this assignment, you are solving this problem numerically.

### Part C: Numerical Solution

1. Assume the following numerical values:

   | Parameter | Value |
   | :---: | :---: |
   | $A_1$ | $1$ |
   | $A_2$ | $1.5$ |
   | $\alpha_1$ | $0.7$ |
   | $\alpha_2$ | $1-\alpha_1 = 0.3$ |
   | $\bar{L}$ | $1$ |
   | $w$ | $1$ |

   Solve for the optimal prices, denoted $p_1^*$ and $p_2^*$.

1. Solve for the expenditure share $s_1$ (and verify that $s_2 = 1-s_1$, although this is fairly trivially satisfied).
1. Solve for the quantities $q_1^*$ and $q_2^*$ associated with the prices in the previous question.
1. Calculate the mark-up over marginal costs for each good. Which producer charges a higher mark-up? What is the intuition for the difference in markups?

1. Solve for $\ell_1^*,\ell_2^*$ via $q_i^*=A_i\ell_i^*$ and verify $\ell_1^*+\ell_2^*=\bar L$.
### Appendix

1. Suppose you only observed equilibrium prices and expenditure shares $(p_1^*,p_2^*,s_1^*,s_2^*)$ but not $(\alpha_1,\alpha_2)$ directly. Using the demand system, can you back out the ratio $\alpha_1/\alpha_2$ from observed data?

   This is the logic behind empirically estimating CES "quality" or "taste" parameters (e.g., in trade/IO demand estimation, à la Feenstra-type CES demand systems).
1. Contrast the role of $\alpha_i$ here with the role of $A_i$: both create a form of asymmetry, but one is a demand-side shifter and one is a cost-side shifter. Explain why, in equilibrium, they are not observationally equivalent even though both can generate $p_1^* \ne p_2^*$.
   
   What additional data (e.g., quantities, cost data) would let you distinguish them?

   This question is open-ended. Try to reason through the problem. If you hit a dead-end, no worries.
