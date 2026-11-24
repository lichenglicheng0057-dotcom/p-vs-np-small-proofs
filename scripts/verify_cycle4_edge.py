"""Finite checks for the L-meta-765 draft, not a Lean verification."""

import itertools
import json


GATES = [("or", 2, 4), ("or", 3, 5), ("and", 6, 7),
         ("and", 0, 1), ("or", 8, 9)]
EDGES = [(0, 1), (2, 3), (3, 4), (4, 5), (5, 2)]
WITNESSES = [
    [False, True, False, False, False, False],
    [True, False, False, False, False, False],
    [False, False, False, True, False, False],
    [False, False, True, False, False, False],
    [False, False, False, True, False, False],
    [False, False, True, False, False, False],
]


def reference(bits):
    return any(bits[i] and bits[j] for i, j in EDGES)


def circuit(bits):
    wires = list(bits)
    for op, a, b in GATES:
        if not (a < len(wires) and b < len(wires)):
            raise ValueError("Gate reads a future wire")
        wires.append(wires[a] and wires[b] if op == "and" else wires[a] or wires[b])
    return wires[10]


def main():
    mismatches = [list(bits) for bits in itertools.product([False, True], repeat=6)
                  if circuit(bits) != reference(bits)]
    dependencies = []
    for i, before in enumerate(WITNESSES):
        after = before.copy()
        after[i] = not after[i]
        dependencies.append({
            "input": i, "witness": before, "before": reference(before),
            "after": reference(after), "changes_output": reference(before) != reference(after),
        })
    report = {
        "task": "L-meta-765", "gate_count": len(GATES),
        "truth_table_rows": 64, "mismatch_count": len(mismatches),
        "dependencies": dependencies,
        "all_six_inputs_essential": all(d["changes_output"] for d in dependencies),
        "lower_bound_basis": "Published dep_lower theorem plus the six witnesses; not circuit enumeration",
        "lean_verification": "NOT_RUN", "official_checker": "NOT_RUN",
    }
    print(json.dumps(report, indent=2))
    if mismatches or not report["all_six_inputs_essential"]:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
