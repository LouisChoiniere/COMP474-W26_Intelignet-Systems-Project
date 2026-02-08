; ===============================================
; Rules for os requirements
; ===============================================

(deftemplate os-ram-requirements
    (slot min-ram-gb)
    (slot rec-ram-gb))

(deftemplate os-disk-requirements
    (slot min-disk-gb)
    (slot rec-disk-gb))

; When an OS is selected, assert its RAM and disk requirements as separate facts
(defrule os-requirements
    (using-os ?os-name)
    ?os-fact <- (os-facts
        (name ?os-name)
        (min-ram-gb ?os-min-ram)
        (rec-ram-gb ?os-rec-ram)
        (min-disk-gb ?os-min-disk)
        (rec-disk-gb ?os-rec-disk))
    =>
    (assert (os-ram-requirements
        (min-ram-gb ?os-min-ram)
        (rec-ram-gb ?os-rec-ram)))
    (assert (os-disk-requirements
        (min-disk-gb ?os-min-disk)
        (rec-disk-gb ?os-rec-disk)))
    (retract ?os-fact)
)

; Remove facts about other OSes that are not selected
(defrule remove-unselected-os-facts
    (using-os ?os-name)
    ?other-os <- (os-facts (name ?other&~?os-name))
    =>
    (retract ?other-os)
)

; ===============================================
; Rules for software requirements
; ===============================================

; RAM requirement template and cumulative fact
(deftemplate software-ram-requirements-min
    (slot min-ram-gb)
    (slot rec-ram-gb))

; Storage requirement template and cumulative fact
(deftemplate software-disk-requirements-cumulative
    (slot total-storage-gb))

; Initialize cumulative requirements on startup
(defrule initialize-cumulative-requirements
    (not (software-ram-requirements-min))
    (not (software-disk-requirements-cumulative))
    =>
    (assert (software-ram-requirements-min
        (min-ram-gb 0)
        (rec-ram-gb 0)))
    (assert (software-disk-requirements-cumulative
        (total-storage-gb 0)))
)

; When a software is selected, update the cumulative RAM and disk requirements
(defrule add-software-requirements
    ?using-software <- (using-software ?software-name)
    ?software-facts <- (software-facts
        (name ?software-name)
        (min-ram-gb ?min-ram)
        (rec-ram-gb ?rec-ram)
        (storage-gb ?storage-gb))
    ?current-storage <- (software-disk-requirements-cumulative
        (total-storage-gb ?current-total))
    ?current-ram <- (software-ram-requirements-min
        (min-ram-gb ?current-min-ram)
        (rec-ram-gb ?current-rec-ram))
    =>
    ; Remove the using-software fact since we've processed it
    (retract ?using-software)

    ; Update cumulative storage requirement
    (retract ?current-storage)
    (assert (software-disk-requirements-cumulative
        (total-storage-gb (+ ?current-total ?storage-gb))))

    ; Update cumulative RAM requirement by taking the max of current and new requirements
    (retract ?current-ram)
    (assert (software-ram-requirements-min
        (min-ram-gb (max ?current-min-ram ?min-ram))
        (rec-ram-gb (max ?current-rec-ram ?rec-ram))))

    ; Remove facts about selected software
    (retract ?software-facts)
)

; ===============================================
; Remove facts about unselected software type
; ===============================================

; When a software type is deselected, remove all facts about software of that type
(defrule remove-unselected-software-type-facts-1
    (not-using-software-type ?type)
    ?software-facts <- (software-facts
        (type ?type))
    =>
    (retract ?software-facts)
)

; If no software of that type remains, remove the not-using fact as well
(defrule remove-unselected-software-type-facts-2
    ?not-using <- (not-using-software-type ?type)
    (not (software-facts
        (type ?type)))
    =>
    (retract ?not-using)
)

; ===============================================
; Done when no more software facts remain
; ===============================================

(defrule check-done
    (not (software-facts))
    =>
    (assert (done))
)


; ===============================================
; Calculate and print total requirements
; ===============================================

(deftemplate total-requirements
    (slot min-ram-gb)
    (slot rec-ram-gb)
    (slot min-disk-gb)
    (slot rec-disk-gb))

(deftemplate total-rounded-requirements
    (slot min-ram-gb)
    (slot rec-ram-gb)
    (slot min-disk-gb)
    (slot rec-disk-gb))


(defrule calculate-total-requirements
    ?done <- (done)
    (os-ram-requirements (min-ram-gb ?os-min-ram) (rec-ram-gb ?os-rec-ram))
    (os-disk-requirements (min-disk-gb ?os-min-disk) (rec-disk-gb ?os-rec-disk))
    (software-ram-requirements-min (min-ram-gb ?sw-min-ram) (rec-ram-gb ?sw-rec-ram))
    (software-disk-requirements-cumulative (total-storage-gb ?sw-storage))
    =>
    (retract ?done)
    (assert (total-requirements
        (min-ram-gb (+ ?os-min-ram ?sw-min-ram))
        (rec-ram-gb (+ ?os-rec-ram ?sw-rec-ram))
        (min-disk-gb (+ ?os-min-disk ?sw-storage))
        (rec-disk-gb (+ ?os-rec-disk ?sw-storage))))
)

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
