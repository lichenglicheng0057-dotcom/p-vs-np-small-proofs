import Mathlib
import PEqualNP.Defs
import PEqualNP.MetaComplexity.L112
import PEqualNP.MetaComplexity.L153

namespace PEqualNP.Outside.L_meta_765

open PEqualNP.CircuitLowerBounds PEqualNP.MetaComplexity

def edgeFun (x : Fin 6 → Bool) : Bool :=
  (x 0 && x 1) || (x 2 && x 3) || (x 3 && x 4) ||
    (x 4 && x 5) || (x 5 && x 2)

def fiveGate : Circuit :=
  ⟨[⟨GateOp.or, [2, 4]⟩,
    ⟨GateOp.or, [3, 5]⟩,
    ⟨GateOp.and, [6, 7]⟩,
    ⟨GateOp.and, [0, 1]⟩,
    ⟨GateOp.or, [8, 9]⟩], 10⟩

lemma fiveGate_ok : FanInTwo fiveGate := by
  intro g hg
  simp only [fiveGate, List.mem_cons, List.not_mem_nil, or_false] at hg
  rcases hg with rfl | rfl | rfl | rfl | rfl <;> simp

lemma ofFn6 (x : Fin 6 → Bool) :
    List.ofFn x = [x 0, x 1, x 2, x 3, x 4, x 5] := by
  rw [List.ofFn_succ, List.ofFn_succ, List.ofFn_succ,
    List.ofFn_succ, List.ofFn_succ, List.ofFn_succ, List.ofFn_zero]
  rfl

lemma fiveGate_eval (x : Fin 6 → Bool) :
    fiveGate.eval (List.ofFn x) = edgeFun x := by
  rw [ofFn6]
  unfold edgeFun
  generalize x 0 = a
  generalize x 1 = b
  generalize x 2 = c
  generalize x 3 = d
  generalize x 4 = e
  generalize x 5 = f
  revert a b c d e f
  decide

lemma upper (s : ℕ) (hs : 5 ≤ s) : HasCircuitSize 6 edgeFun s := by
  refine ⟨fiveGate, fiveGate_ok, ?_, fiveGate_eval⟩
  simpa [fiveGate, Circuit.size] using hs

lemma lower (s : ℕ) (h : HasCircuitSize 6 edgeFun s) : 5 ≤ s := by
  have hdep := PEqualNP.MetaComplexity.Helpers.dep_lower 6 edgeFun (fun i => by
    fin_cases i
    · exact ⟨![false, true, false, false, false, false], by decide⟩
    · exact ⟨![true, false, false, false, false, false], by decide⟩
    · exact ⟨![false, false, false, true, false, false], by decide⟩
    · exact ⟨![false, false, true, false, false, false], by decide⟩
    · exact ⟨![false, false, false, true, false, false], by decide⟩
    · exact ⟨![false, false, true, false, false, false], by decide⟩) s h
  omega

end PEqualNP.Outside.L_meta_765

theorem PEqualNP.Outside.L_meta_765 :
    ∀ s : ℕ, PEqualNP.MetaComplexity.HasCircuitSize 6
      (fun x : Fin 6 → Bool => (x 0 && x 1) || (x 2 && x 3) ||
        (x 3 && x 4) || (x 4 && x 5) || (x 5 && x 2)) s ↔ 5 ≤ s := by
  intro s
  exact ⟨PEqualNP.Outside.L_meta_765.lower s,
    PEqualNP.Outside.L_meta_765.upper s⟩
