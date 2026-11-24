# Small proof candidates for P vs NP

This personal project records small lemma candidates related to the open [pequalnp](https://pequalnp.com/) effort. It does not claim to resolve P versus NP or to represent the official project.

## Current candidate: L-meta-765

The target is the exact circuit size of the edge function of a four-cycle and a disjoint edge. The proposed proof combines an explicit five-gate circuit with the existing support lower bound: all six inputs are essential, so at least five fan-in-two gates are required.

| Check | Status |
| --- | --- |
| Five-gate construction on all 64 inputs | PASS |
| A dependence witness for each of the six inputs | PASS |
| Lean compilation of this candidate | NOT VERIFIED: the local build was stopped during dependency preparation |
| Official checker / accepted contribution | NOT RUN / NOT ACCEPTED |

Finite checks support the construction and the witnesses; they do not replace formal verification of the complete theorem. The Lean file is an unverified candidate and may require corrections.

Files:

- `proofs/L_meta_765.lean`: the candidate with the original posted statement.
- `scripts/verify_cycle4_edge.py`: a Python standard-library finite check; run `python scripts/verify_cycle4_edge.py`.
- `LICENSE`: Apache License 2.0, consistent with the upstream proof repository.

## Upstream context and submission

The statement, definitions and existing supporting lemmas come from [brilliant-hq/pequalnp-proofs](https://github.com/brilliant-hq/pequalnp-proofs), reviewed locally at commit `198cfc2b632227c5113cd2afde52a74a0dd9f532`. The candidate uses `PEqualNP.MetaComplexity.Helpers.dep_lower`, available through the allowed `L112` dependency chain. These existing library results are not claimed as original work here.

The task is [L-meta-765](https://pequalnp.com/lemma#L-meta-765). Its current availability must be checked again before any submission. This account has not been assigned the task, and no upstream pull request has been submitted for this candidate.

Before an upstream submission, follow the [official participation instructions](https://pequalnp.com/join.txt) and [contribution rules](https://github.com/brilliant-hq/pequalnp-proofs/blob/main/CONTRIBUTING.md): obtain the applicable task assignment, avoid duplicate work, establish that the exact statement builds, and submit only the one designated Lean file through an appropriate fork. This personal repository is a record of work, not a request for the maintainers to review unfinished code outside that process.
