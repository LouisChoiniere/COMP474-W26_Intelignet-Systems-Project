(defrule check-software-requirements
    (using-software (name ?sname))
    ?software <- (software-requirements
                    (name ?sname)
                    (min-ram-gb ?min-ram)
                    (rec-ram-gb ?rec-ram)
                    (storage-gb ?storage)
                    (min-vram-gb ?min-vram)
                    (gpu-intensive ?gpu-intensive)
                    (gpu-performance ?required-gpu-performance)
                    (directx-requirement ?dx))
    ?computer <- (user-computer
                    (ram-size ?ram-size)
                    (cpu-performance ?cpu-performance)
                    (storage-gb ?computer-storage)
                    (gpu-memory ?gpu-memory)
                    (gpu-performance ?gpu-performance)
                    (directx-versions $?directx-versions))
=>
    (printout t "Checking if " ?sname " can run on the user's computer..." crlf)
)

; This rule will catch any software that the user is using but for which we have no requirements in our knowledge base.
; It will assume that such software might run, but we won't know how well it will run.
; This has a certainty factor of 1.0 because we are certain that we have no information about this software, so we are fully uncertain about its performance.
(defrule no-software-requirements
    (declare (CF 1.0))
    (using-software (name ?sname))
    (not (program-run-how-well (name ?sname))) ; Only apply if we haven't assessed the program.
    (not (software-requirements (name ?sname)))
=>
    (assert (program-run-how-well
        (name ?sname)
        (will-run maybe)
        (how-well unknown)))
    (printout t "No requirements found for " ?sname ". Assuming it might run with unknown performance." crlf)    
)

; This rule checks if the software cannot run due to insufficient RAM.
; It has a high certainty factor because RAM is a critical requirement for running software,
; and if the computer's RAM is below the minimum required, it's very likely that the software will not run at all.
(defrule no-run-due-to-ram
    (declare (CF 0.90))
    (using-software (name ?sname))
    (not (program-run-how-well (name ?sname)))
    
    ?software <- (software-requirements
                    (name ?sname)
                    (min-ram-gb ?min-ram))
    
    ?computer <- (user-computer
                    (ram-size ?ram-size))
    
    (test (< ?ram-size ?min-ram))
=>
    (assert (program-run-how-well
        (name ?sname)
        (will-run no)
        (how-well poor)))
    (printout t ?sname " cannot run due to insufficient RAM." crlf)
)


; This rule checks if the software cannot run due to insufficient storage.
; It has a high certainty factor because storage is also a critical requirement.
(defrule no-run-due-to-storage
    (declare (CF 0.85))
    (using-software (name ?sname))
    (not (program-run-how-well (name ?sname)))
    
    ?software <- (software-requirements
                    (name ?sname)
                    (storage-gb ?storage))
    
    ?computer <- (user-computer
                    (storage-gb ?computer-storage))
    
    (test (< ?computer-storage ?storage))
=>
    (assert (program-run-how-well
        (name ?sname)
        (will-run no)
        (how-well poor)))
    (printout t ?sname " cannot run due to insufficient storage." crlf)
)