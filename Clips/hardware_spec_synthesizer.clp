; (clear)
; (load "function.clp")
; (load "rulebase.clp")
; (load "factbase.clp")


; ===============================================
; List available os to user and ask for selection
; ===============================================

(defrule ask-for-os
    =>
    (printout t "Available Operating Systems:" crlf)

    (do-for-all-facts ((?os os-facts)) TRUE
        (printout t "- " ?os:name crlf))
    
    (printout t "Please enter the name of the operating system you want to use: ")
    
    (bind ?selected-os (read))
    (assert (using-os ?selected-os))
)

; ===============================================
; List available software type to user and ask for selection
; ===============================================

(defrule ask-for-software-type
    (using-os ?os-name)
    =>
    (printout t "Available Software Types:" crlf)
    
    (do-for-all-facts ((?st software-type-facts)) TRUE
        (printout t "- " ?st:type crlf))
    
    (printout t "Enter the software types that you wish to use (separated by commas): ")
    (bind ?input (read))

    (bind ?selection (parse-comma-separated ?input)) ; Parse comma-separated input using the function
    
    ; Assert each selected software type
    (foreach ?selected-type ?selection
        (assert (using-software-type ?selected-type))
    )
)



; ===============================================
; List available software to user and ask for selection
; ===============================================

(defrule ask-for-software
    ?st <- (using-software-type ?type)
    =>
    (printout t "Available Software in " ?type " category:" crlf)
    
    (do-for-all-facts ((?sw software-facts)) (eq ?sw:type ?type)
    (printout t "- " ?sw:name crlf))
    
    (printout t "Enter the software names that you wish to use (separated by commas): ")
    (bind ?input (read))

    (bind ?selection (parse-comma-separated ?input)) ; Parse comma-separated input using the function

    ; Assert each selected software
    (foreach ?selected-software ?selection
        (assert (using-software ?selected-software))
    )
)

; ===============================================
; Print total requirements
; ===============================================

(defrule print-total-requirements
    ?total <- (total-requirements
        (min-ram-gb ?min-ram)
        (rec-ram-gb ?rec-ram)
        (min-disk-gb ?min-disk)
        (rec-disk-gb ?rec-disk))
    =>
    (printout t "Total Minimum RAM Required: " ?min-ram " GB (nearest available size " (ram-rounded ?min-ram) " GB)" crlf)
    (printout t "Total Recommended RAM Required: " ?rec-ram " GB (nearest available size " (ram-rounded ?rec-ram) " GB)" crlf)
    (printout t "Total Minimum Disk Space Required: " ?min-disk " GB (nearest available size " (disk-rounded ?min-disk) " GB)" crlf)
    (printout t "Total Recommended Disk Space Required: " ?rec-disk " GB (nearest available size " (disk-rounded ?rec-disk) " GB)" crlf)
    (retract ?total)
)