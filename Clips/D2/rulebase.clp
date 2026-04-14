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