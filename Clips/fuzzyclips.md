## Language extention to use fuzzy logic

FuzzyCLIPS uses similar structure to CLIPS:
- Facts
- Rules
- Inference engine
Additional fuzzy features include:
- Fuzzy variables
- Membership functions
- Fuzzy reasoning


Fuzzy variables are used to represent vague concepts
- Temperature

Possible fuzzy values
- Low
- Medium
- High


Example:
```
(temperature high)

(defrule turn-on-fan
    (temperature high)
=> (
    printout t "Fan should be turned on" crlf)
)
```


Templates in FuzzyClips
```
(deftemplate <name> [“<comments>”]
<from> <to> [<unit>] ; universe of discourse
(
    t1
    .
    . ; list of primary terms
    .
    tn
)
)

; Example
; Defines a a fuzzy variable age, with a universe ranging between 0 to 120 years. Its fuzzy slots include young and old (young starts at fully true then decreases to 0 at 50 years)
(deftemplate age
0 120 years
(
(young (25 1) (50 0))
(old (50 0) (65 1))
)
)
```

Assertion
Assert exact age: `(assert (age (30 1)))`
Assert uncertain age: `(assert (age (25 0.5) (30 1) (35 0.5)))`
Assert using linguistics: `(assert (age young))`

---


Similar to rules in CLIPS:
```
(defrule is-student
    (age young)
=>
    (assert (category student))
)
```
If age overlaps with young age, then assert that category is student. Problems
with this:

To fix this create a fuzzy template for category:
```
(deftemplate category
    01
    (
        (student (0 0) (1 1))
    )
))
```
Then asserting a student will have a corresponding fuzzy set with
strength from 0 to 1 attached to it.


Fuzzy Logic shows how true something is
(concerned with vagueness)
Certainty Factor shows how sure we are of a fact
(concerned with confidence)


To assign a certainty factor:
(assert (symptom fever) CF 0.8)

assert (symptom fever) CF 0.8)
(defrule fever-flu
(declare (CF 0.7))
(symptom (name fever))
=>
(assert (disease (name flu)))
)
Results is (disease (name flu)) CF 0.56
(CF output is 0.8*0.7 = 0.56)

(assert (symptom fever) CF 0.8)(assert (symptom cough) CF 0.6)
(defrule fever-flu
(declare (CF 0.7))
(symptom (name cough))
=>
(assert (disease (name flu)))
)(defrule cough-flu
(declare (CF 1))
(symptom (name cough))
=>
(assert (disease (name flu)))
)
Results is (disease (name flu)) CF 0.6
(CF output is max(0.8*0.7, 1 * 0.6) = 0.6)