; ==================== Certainty Factor Rules for Software Compatibility ====================

; This rule will catch any software that the user is using but for which we have no requirements in our knowledge base.
; It will assume that such software might run, but we won't know how well it will run.
(defrule no-software-requirements
    (declare (salience 99) (CF 0.01))
    (using-software (name ?sname))
    ; (not (program-run (name ?sname))) ; Only apply if we haven't assessed the program.
    (not (software-requirements (name ?sname)))
=>
    (assert (program-run
        (name ?sname)))
    (printout t "No requirements found for " ?sname ". Assuming it might run with unknown performance." crlf)    
)

; This rule checks if the software cannot run due to insufficient RAM.
(defrule no-run-due-to-ram
    (declare (salience 10) (CF 0.1))
    (using-software (name ?sname))
    ; (not (program-run (name ?sname)))
    
    ?software <- (software-requirements
                    (name ?sname)
                    (min-ram-gb ?min-ram))
    
    ?computer <- (user-computer
                    (ram-size ?ram-size))
    
    (test (< ?ram-size ?min-ram))
=>
    (assert (program-run
        (name ?sname)))
    (printout t ?sname " cannot run due to insufficient RAM." crlf)
)


; This rule checks if the software cannot run due to insufficient storage.
(defrule no-run-due-to-storage
    (declare (salience 10) (CF 0.1))
    (using-software (name ?sname))
    ; (not (program-run (name ?sname)))
    
    ?software <- (software-requirements
                    (name ?sname)
                    (storage-gb ?storage))
    
    ?computer <- (user-computer
                    (storage-gb ?computer-storage))
    
    (test (< ?computer-storage ?storage))
=>
    (assert (program-run
        (name ?sname)))

    (printout t ?sname " cannot run due to insufficient storage." crlf)
)

; This rule checks if the software cannot run due to insufficient GPU memory.
(defrule no-run-due-to-gpu-memory
    (declare (salience 10) (CF 0.1))
    (using-software (name ?sname))
    ; (not (program-run (name ?sname)))
    
    ?software <- (software-requirements
                    (name ?sname)
                    (min-vram-gb ?min-vram))
    
    ?computer <- (user-computer
                    (gpu-memory ?gpu-memory))
    
    (test (< ?gpu-memory ?min-vram))
=>
    (assert (program-run
        (name ?sname)))

    (printout t ?sname " cannot run due to insufficient GPU memory." crlf)
)

; This rule checks if the software cannot run due to missing DirectX support.
(defrule no-run-directx-requirement
    (declare (salience 10) (CF 0.1))
    (using-software (name ?sname))
    ; (not (program-run (name ?sname)))
    
    ?software <- (software-requirements
                    (name ?sname)
                    (directx-requirement ?dx))
    
    ?computer <- (user-computer
                    (directx-versions $?directx-versions))
    
    (test (and (not (eq ?dx none)) ; If the software requires a specific DirectX version
               (not (member$ ?dx ?directx-versions)))) ; and the computer does not support it
=>
    (assert (program-run
        (name ?sname)))
    
    (printout t ?sname " cannot run due to DirectX requirement not met." crlf)
)

; This rule checks if the software is likely to run well, which means it meets the minimum requirements.
(defrule good-run
    (declare (salience 45) (CF 0.70))
    (using-software (name ?sname))
    (not (program-run (name ?sname)))
    
    ?software <- (software-requirements
                    (name ?sname)
                    (min-ram-gb ?min-ram)
                    (storage-gb ?storage)
                    (min-vram-gb ?min-vram)
                    (gpu-intensive ?gpu-intensive)
                    (directx-requirement ?dx))
    
    ?computer <- (user-computer
                    (ram-size ?ram-size)
                    (storage-gb ?computer-storage)
                    (gpu-memory ?gpu-memory)
                    (directx-versions $?directx-versions))
    
    (test (and 
        (>= ?ram-size ?min-ram) ; RAM meets minimum requirement
        (>= ?computer-storage ?storage) ; Storage meets requirement
        (>= ?gpu-memory ?min-vram) ; GPU memory meets requirement
        (or (eq ?dx none) (member$ ?dx ?directx-versions)) ; DirectX requirement is met
    ))
=>
    (assert (program-run
        (name ?sname)))
    (printout t ?sname " is likely to run well on the user's computer." crlf)
)

; This rule checks if the software is likely to run excellently, which means it exceeds the recommended requirements.
(defrule excellent-run
    (declare (salience 50) (CF 0.95))
    (using-software (name ?sname))
    (not (program-run (name ?sname)))
    
    ?software <- (software-requirements
                    (name ?sname)
                    (min-ram-gb ?min-ram)
                    (rec-ram-gb ?rec-ram)
                    (storage-gb ?storage)
                    (min-vram-gb ?min-vram)
                    (gpu-intensive ?gpu-intensive)
                    (directx-requirement ?dx))
    
    ?computer <- (user-computer
                    (ram-size ?ram-size)
                    (storage-gb ?computer-storage)
                    (gpu-memory ?gpu-memory)
                    (directx-versions $?directx-versions))
    
    (test (and 
        (> ?ram-size ?rec-ram) ; RAM exceeds recommended requirement
        (> ?computer-storage (* 1.5 ?storage)) ; Storage exceeds requirement by a good margin
        (> ?gpu-memory (* 1.5 ?min-vram)) ; GPU memory exceeds requirement by a good margin
        (or (eq ?dx none) (member$ ?dx ?directx-versions)) ; DirectX requirement is met
    ))
=>
    (assert (program-run
        (name ?sname)))
    
    (printout t ?sname " is likely to run excellently on the user's computer." crlf)
)


; Add missing requirements
(defrule not-enough-ram
    (declare (CF 0.9))
    (using-software (name ?sname))
    
    ?software <- (software-requirements
                    (name ?sname)
                    (min-ram-gb ?min-ram))
    
    ?computer <- (user-computer
                    (ram-size ?ram-size))
    
    (test (< ?ram-size ?min-ram))
=>
    (assert (missing-requirement
        (name ram)))    
)

(defrule not-enough-storage
    (declare (CF 0.9))
    (using-software (name ?sname))
    
    ?software <- (software-requirements
                    (name ?sname)
                    (storage-gb ?storage))
    
    ?computer <- (user-computer
                    (storage-gb ?computer-storage))
    
    (test (< ?computer-storage ?storage))
=>
    (assert (missing-requirement
        (name storage)))
)

(defrule not-enough-gpu-memory
    (declare (CF 0.9))
    (using-software (name ?sname))
    
    ?software <- (software-requirements
                    (name ?sname)
                    (min-vram-gb ?min-vram))
    
    ?computer <- (user-computer
                    (gpu-memory ?gpu-memory))
    
    (test (< ?gpu-memory ?min-vram))
=>
    (assert (missing-requirement
        (name gpu-memory)))
)

(defrule directx-requirement-not-met
    (declare (CF 0.9))
    (using-software (name ?sname))
    
    ?software <- (software-requirements
                    (name ?sname)
                    (directx-requirement ?dx))
    
    ?computer <- (user-computer
                    (directx-versions $?directx-versions))
    
    (test (and (not (eq ?dx none)) ; If the software requires a specific DirectX version
               (not (member$ ?dx ?directx-versions)))) ; and the computer does not support it
=>
    (assert (missing-requirement
        (name directx)))
)

; ==================== Fuzzy Logic Rules for Software Compatibility ====================

; Step 1: Start a fuzzy analysis pass once the computer and software inputs exist.
(defrule start-computer-analysis
    (declare (salience 20))
    ?computer <- (user-computer)
    (using-software (name ?sname))
    (not (computer-analysis (stage started)))
=>
    (assert (computer-analysis (stage started)))
    (printout t "Starting fuzzy computer analysis." crlf)
)

; Step 2: Convert missing-requirement facts into explicit gap facts.
(defrule mark-ram-gap
    (declare (salience 15))
    (computer-analysis (stage started))
    (missing-requirement (name ram))
    (not (computer-gap (name ram)))
=>
    (assert (computer-gap (name ram)))
    (printout t "Gap detected: RAM." crlf)
)

(defrule mark-storage-gap
    (declare (salience 15))
    (computer-analysis (stage started))
    (missing-requirement (name storage))
    (not (computer-gap (name storage)))
=>
    (assert (computer-gap (name storage)))
    (printout t "Gap detected: storage." crlf)
)

(defrule mark-gpu-gap
    (declare (salience 15))
    (computer-analysis (stage started))
    (missing-requirement (name gpu-memory))
    (not (computer-gap (name gpu-memory)))
=>
    (assert (computer-gap (name gpu-memory)))
    (printout t "Gap detected: GPU memory." crlf)
)

(defrule mark-directx-gap
    (declare (salience 15))
    (computer-analysis (stage started))
    (missing-requirement (name directx))
    (not (computer-gap (name directx)))
=>
    (assert (computer-gap (name directx)))
    (printout t "Gap detected: DirectX support." crlf)
)

; Step 3: Turn the demanding cyberpunk outcome into a high-risk signal.
(defrule mark-high-demand-risk
    (declare (salience 12))
    (computer-analysis (stage started))
    (software-requirements 
        (name ?sname)
        (gpu-intensive yes))
    (program-run (name ?sname))
    (not (computer-risk (level high)))
=>
    (assert (computer-risk (level high)))
    (printout t "High-demand software risk detected: " ?sname crlf)
)

; Step 4: Convert the evidence into a fuzzy assessment fact.
(defrule assess-high-effectiveness
    (declare (salience 0))
    (computer-analysis (stage started))
    (program-run (name ?program))
    (not (computer-gap (name ram)))
    (not (computer-gap (name storage)))
    (not (computer-gap (name gpu-memory)))
    (not (computer-gap (name directx)))
    (not (computer-risk (level high)))
    (not (computer-assessment (performance-gap ?existing-assessment)))
=>
    (assert (computer-assessment (performance-gap no-upgrade-needed)))
    (printout t "Assessment fact asserted: no-upgrade-needed." crlf)
)

(defrule assess-medium-effectiveness
    (declare (salience 0))
    (computer-analysis (stage started))
    (computer-gap (name ?gap))
    (not (computer-risk (level high)))
    (not (computer-assessment (performance-gap ?existing-assessment)))
=>
    (assert (computer-assessment (performance-gap consider-upgrade)))
    (printout t "Assessment fact asserted: consider-upgrade." crlf)
)

(defrule assess-low-effectiveness
    (declare (salience 5))
    (computer-analysis (stage started))
    (computer-gap (name ?gap))
    (computer-risk (level high))
    (not (computer-assessment (performance-gap ?existing-assessment)))
=>
    (assert (computer-assessment (performance-gap upgrade-needed)))
    (printout t "Assessment fact asserted: upgrade-needed." crlf)
)

; Step 5: Materialize one final recommendation with priority.
; Priority: upgrade-needed > consider-upgrade > no-upgrade-needed.
(defrule recommend-upgrade-needed
    (declare (salience -5))
    (computer-assessment (performance-gap upgrade-needed))
    (not (need-for-upgrade (performance-gap upgrade-needed)))
=>
    (assert (need-for-upgrade (performance-gap upgrade-needed)))
)

(defrule recommend-consider-upgrade
    (declare (salience -6))
    (computer-assessment (performance-gap consider-upgrade))
    (not (need-for-upgrade (performance-gap upgrade-needed)))
    (not (need-for-upgrade (performance-gap consider-upgrade)))
=>
    (assert (need-for-upgrade (performance-gap consider-upgrade)))
)

(defrule recommend-no-upgrade-needed
    (declare (salience -7))
    (computer-assessment (performance-gap no-upgrade-needed))
    (not (need-for-upgrade (performance-gap upgrade-needed)))
    (not (need-for-upgrade (performance-gap consider-upgrade)))
    (not (need-for-upgrade (performance-gap no-upgrade-needed)))
=>
    (assert (need-for-upgrade (performance-gap no-upgrade-needed)))
)

; Step 6: Print exactly one summary line group.
(defrule print-computer-assessment-summary-low
    (declare (salience -10))
    (need-for-upgrade (performance-gap upgrade-needed))
    (not (analysis-summary (status printed)))
=>
    (assert (analysis-summary (status printed)))
    (printout t crlf "COMPUTER EFFECTIVENESS SUMMARY" crlf)
    (printout t "  Fuzzy result: upgrade-needed" crlf)
    (printout t "  Interpretation: the machine is not a good fit for the requested software." crlf)
)

(defrule print-computer-assessment-summary-medium
    (declare (salience -11))
    (need-for-upgrade (performance-gap consider-upgrade))
    (not (need-for-upgrade (performance-gap upgrade-needed)))
    (not (analysis-summary (status printed)))
=>
    (assert (analysis-summary (status printed)))
    (printout t crlf "COMPUTER EFFECTIVENESS SUMMARY" crlf)
    (printout t "  Fuzzy result: consider-upgrade" crlf)
    (printout t "  Interpretation: the machine works, but has visible limits." crlf)
)

(defrule print-computer-assessment-summary-high
    (declare (salience -12))
    (need-for-upgrade (performance-gap no-upgrade-needed))
    (not (need-for-upgrade (performance-gap consider-upgrade)))
    (not (need-for-upgrade (performance-gap upgrade-needed)))
    (not (analysis-summary (status printed)))
=>
    (assert (analysis-summary (status printed)))
    (printout t crlf "COMPUTER EFFECTIVENESS SUMMARY" crlf)
    (printout t "  Fuzzy result: no-upgrade-needed" crlf)
    (printout t "  Interpretation: the machine is sufficient for the requested software." crlf)
)