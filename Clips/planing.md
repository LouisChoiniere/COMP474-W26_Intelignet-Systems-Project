## Plan: Phase 2 - Uncertain Knowledge in Hardware Synthesizer

**TL;DR:** Expand GPU modeling and software database (Phase 2A), then independently implement three uncertainty frameworks: Certainty Factors (2B) and Dempster-Shafer (2C) for probabilistic reasoning, and Fuzzy Logic (2D) for possibilistic reasoning. Each uncertainty framework adds 5+ facts and 10+ rules as required.

*Note: Reference FuzzyCLIPS610d.pdf for syntax and fuzzy logic*

---

## Steps

### **PHASE 2A: Foundation & Database Expansion**
*Prerequisite for all frameworks; enables GPU-aware recommendations*

1. **Expand GPU Requirements** (standalone)
   - Enhance `os-facts`: add min-vram-gb, rec-vram-gb, gpu-api-versions
   - Update `software-facts`: add vram-gb requirement and gpu-intensive flag
   - Add GPU validation rules to rulebase.clp

2. **Grow Software Database** (parallel with step 1)
   - Add 15+ new software: Docker, Kubernetes, Maya, Cyberpunk2077, OBS, Teams, Discord, etc.
   - Include 5+ graphics-intensive entries with VRAM specs
   - Ensure all entries have complete os-compatibility and resource specs

3. **Introduce Uncertainty Foundation Facts** (depends on step 2)
   - Create `software-compatibility-confidence` template in new file (separate uncertainty knowledge logic)
   - Add 5–10 base uncertainty facts for cross-platform software (e.g., IntelliJ on Linux: 0.95 confidence; VS on Linux: 0.15)

---

### **PHASE 2B: Certainty Factors Framework**
*New file: `cf-uncertainty.clp`*

4. **CF Foundation** (5+ facts)
   - Templates: `cf-hardware-capability`, `cf-software-demand`, `cf-compatibility-evidence`
   - 5 base facts: hardware CF values (RTX3080 → CF=0.9 for gaming)
   - 5 base facts: software demand certainty levels

5. **CF Inference Rules** (10+ rules)
   - Multi-source CF combination
   - OS → software → performance CF propagation
   - Negation handling (negative CF for incompatibility)
   - CF decay under hardware uncertainty
   - Multi-program CF aggregation
   - Threshold warnings (CF < 0.5)
   - User-proficiency-based CF adjustment
   - CF-qualified recommendations output

---

### **PHASE 2C: Dempster-Shafer Framework**
*New file: `ds-uncertainty.clp`*

6. **D-S Foundation** (5+ facts)
   - Templates: `ds-belief-assignment`, `ds-evidence-source`, `ds-focal-elements`
   - 5 base mass assignments (hardware detection uncertainty)
   - 5 focal elements for software-OS compatibility

7. **D-S Inference Rules** (10+ rules)
   - Dempster's combination rule for evidence fusion
   - Belief (Bel) / Plausibility (Pl) calculation
   - Frame-of-discernment handling
   - Multi-software aggregate uncertainty
   - GPU API → software feature propagation
   - Ignorance region identification
   - Conflict detection & resolution
   - Mass refinement via user feedback
   - [Bel, Pl] interval recommendation output

---

### **PHASE 2D: Fuzzy Logic Framework**
*New file: `fuzzy-uncertainty.clp`*

8. **Fuzzy Foundation** (5+ facts)
   - Fuzzy sets: RAM (low/medium/high/very-high), GPU capability (inadequate/acceptable/capable/excellent), software demand (light/moderate/heavy/extreme), storage (sparse/normal/tight/overcrowded)
   - Template: `fuzzy-hardware-profile`
   - 5+ base fuzzy facts with realistic membership curves

9. **Fuzzy Inference Rules** (10+ rules)
   - Fuzzification: RAM GB → membership in fuzzy sets
   - Software demand fuzzification
   - Fuzzy composition (AND logic for multi-software)
   - Fuzzy adequacy inference
   - De-fuzzification to suitability score (0–100)
   - De-fuzzify to linguistic output (WELL-SUITED / MARGINAL / UNSUITABLE)
   - Fuzzy tolerance (slightly underpowered but acceptable)
   - GPU fuzzy matching
   - Linguistic hedges (VERY, QUITE, SOMEWHAT suitable)
   - Boundary case exception handling

---

## Verification

**Phase 2A:**
1. Select Windows-11 + Unreal Engine → GPU VRAM requirement calculated and displayed
2. All 15+ new software load without errors; Filter correctly by OS compatibility
3. GPU-intensive flag and DirectX version propagate correctly through rules

**Phase 2B (CF):**
1. Load cf-uncertainty.clp; assert sample hardware and trace rule firing
2. Multi-software: verify CF = CF1 + CF2 − (CF1 × CF2) when both positive
3. Weak hardware + strong demand → CF warning triggers
4. Output: "87% confidence this PC handles your workflow"

**Phase 2C (D-S):**
1. Load ds-uncertainty.clp; initialize focal elements
2. Dempster's rule: merge two evidence sources correctly; verify Σ(mass) = 1.0
3. Calculate [Bel, Pl] intervals for test scenario
4. Incompatible GPU API → conflict detection triggers

**Phase 2D (Fuzzy):**
1. Load fuzzy-uncertainty.clp; fuzzify crisp RAM → output membership in "medium"
2. 2×heavy programs + medium PC → output "marginal suitability"
3. De-fuzzify result → suitability 0–100 score
4. GPU gap → output "capability gap is MODERATE"

**Integration:**
1. reset.clp loads all three frameworks without conflicts
2. User choice prompt: select CF / D-S / Fuzzy
3. Run identical scenario through all three methods; outputs consistent semantically
4. 5+ test scenarios (gaming PC, dev workstation, budget user, etc.) pass all frameworks

---

## Decisions & Scope

**Included:**
- Complete GPU modeling (VRAM, APIs, DirectX versions, graphics intensity)
- 15+ new software expanding all categories
- Two probabilistic frameworks (CF + D-S)
- One possibilistic framework (Fuzzy Logic)
- User-selectable reasoning method
- Updated GPU-aware prompts

**Excluded (Phase 2):**
- Hardware auto-detection
- Multi-objective optimization (cost vs. performance)
- Market price data

---

## Further Considerations

1. **Backward Compatibility** — Keep "basic mode" (no uncertainty) as option? **YES** — add flag to skip uncertainty for simpler queries.

2. **Performance Scaling** — More rules = longer runtime. Lazy-load uncertainty calculations when requested? **YES** — use rule salience to prioritize.

3. **User Communication Unified Output** — CF/D-S/Fuzzy produce different formats. Create unified "confidence summary" layer? **YES** — post-process all three into single 0–100 suitability + confidence level.
