# Exact circuit size of the edge function of C4 ⊔ K2

Author: 郝东春 ([lichenglicheng0057-dotcom](https://github.com/lichenglicheng0057-dotcom)) · First published: 2026-11-24

An elementary mathematical proof with reproducible finite checks. The associated Lean file is an **unverified formalization draft**; no upstream acceptance is claimed.

## Model and theorem

Let $x\in\{0,1\}^6$ and

$$E=\{\{0,1\},\{2,3\},\{3,4\},\{4,5\},\{5,2\}\}.$$

This is a four-cycle on vertices 2, 3, 4, 5 and a disjoint edge on 0, 1. Its edge function is

$$f(x)=\bigvee_{\{i,j\}\in E}(x_i\land x_j).$$

Circuits are straight-line, single-output Boolean circuits with AND/OR/NOT gates of fan-in at most two and unrestricted sharing and fan-out. Size counts gates, excluding primary inputs and wires. The upstream model also permits zero-input gates and reads missing wires as false. A forward or missing reference contributes a constant, not a dependency on a primary input.

**Theorem.** The minimum circuit size of $f$ is 5. Equivalently, for every natural number $s$, a circuit with at most $s$ gates exists if and only if $5\le s$.

## Upper bound

Distributivity and commutativity give

$$(x_2\lor x_4)\land(x_3\lor x_5)
=(x_2\land x_3)\lor(x_3\land x_4)\lor(x_4\land x_5)\lor(x_5\land x_2).$$

Thus

$$f=(x_0\land x_1)\lor((x_2\lor x_4)\land(x_3\lor x_5)).$$

Number the primary-input wires 0 through 5 and the new gate wires consecutively:

| Gate | Output wire | Operation | Input wires |
| --- | --- | --- | --- |
| 1 | 6 | OR | 2, 4 |
| 2 | 7 | OR | 3, 5 |
| 3 | 8 | AND | 6, 7 |
| 4 | 9 | AND | 0, 1 |
| 5 | 10 | OR | 8, 9 |

The output is wire 10. All gates read earlier wires. This formula is read-once: each primary variable occurs once. The verifier compares this gate list with the independent edge-list specification on all $2^6=64$ assignments.

## Lower bound

### Six essential variables

For each $i$, set a neighbor $j$ to 1 and every other variable to 0. The initial output is 0; changing $x_i$ from 0 to 1 makes the edge $\{i,j\}$ true.

| Variable $i$ | Neighbor $j$ fixed at 1 |
| --- | --- |
| 0 | 1 |
| 1 | 0 |
| 2 | 3 |
| 3 | 2 |
| 4 | 3 |
| 5 | 2 |

Every variable can therefore affect the output while the other five are fixed.

### Support bound for general circuits

A single-output circuit depending essentially on $n$ primary inputs needs at least $n-1$ gates if each gate has fan-in at most two.

Retain only gates and primary inputs that are ancestors of the output. Discard references that read the default constant false, since they introduce no input dependency. Every essential input must remain: a variable absent from the dependency graph cannot change the output.

Let $m$ be the number of primary inputs in the retained graph, so $m\ge n$, and let $g$ be its number of gates. The underlying undirected graph has $m+g$ vertices and is connected, because every retained vertex has a path to the output. It has at least $m+g-1$ distinct edges. Each gate has at most two incoming wires, so it has at most $2g$ distinct edges; repeated wires only reduce this upper bound. Therefore

$$m+g-1\le2g,\qquad g\ge m-1\ge n-1.$$

The original circuit has at least $g$ gates. This counts the circuit DAG itself and permits shared subcircuits, free fan-out, NOT gates and constant gates. It does not assume a formula or a monotone circuit.

Here $n=6$, so at least 5 gates are necessary. The construction achieves that bound. For $s\ge5$ the same construction has at most $s$ gates; for $s<5$ the lower bound excludes a circuit. This proves the theorem.

## Computational and formal boundaries

[The verifier](../scripts/verify_cycle4_edge.py) checks gate ordering, all 64 outputs and six dependence witnesses. [The recorded result](../results/finite-check.json) is reproducible with the Python standard library. No search over all circuits is performed; the universal lower bound comes from the proof above.

[The Lean draft](../proofs/L_meta_765.lean) follows the same route using the upstream dep_lower theorem, and preserves the posted L-meta-765 statement. Its local build was deliberately stopped during dependency compilation. Neither completion of that formalization nor official acceptance is asserted.

## Sources and provenance

At reviewed upstream commit 198cfc2b632227c5113cd2afde52a74a0dd9f532:

1. [Circuit-size and fan-in definitions](https://github.com/brilliant-hq/pequalnp-proofs/blob/198cfc2b632227c5113cd2afde52a74a0dd9f532/lean/PEqualNP/Defs/MetaComplexity.lean).
2. [Existing support bound, dep_lower](https://github.com/brilliant-hq/pequalnp-proofs/blob/198cfc2b632227c5113cd2afde52a74a0dd9f532/lean/PEqualNP/MetaComplexity/Helpers/Support.lean).
3. [Existing three-gate construction for C4](https://github.com/brilliant-hq/pequalnp-proofs/blob/198cfc2b632227c5113cd2afde52a74a0dd9f532/lean/PEqualNP/MetaComplexity/Helpers/ExactCycle4.lean).
4. [Public task L-meta-765](https://pequalnp.com/lemma#L-meta-765).

The support bound and C4 factorization are existing methods. This repository supplies a self-contained presentation, explicit circuit/witness record and reproducible code for the special case; historical novelty is not established. AI assistance was used in drafting. Cite a fixed repository commit for a particular version and upstream sources for their general results and definitions.
