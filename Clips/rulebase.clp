; ===============================================
; Rules for os requirements
; ===============================================

(deftemplate os-ram-requirements
    (slot min-ram-gb)
    (slot rec-ram-gb))

(deftemplate os-disk-requirements
    (slot min-disk-gb)
    (slot rec-disk-gb))

(deftemplate os-gpu-requirements
    (slot min-vram-gb)
    (slot rec-vram-gb)
    (multislot gpu-api-versions))

; When an OS is selected, assert its RAM and disk requirements as separate facts
(defrule os-requirements
    (declare (salience 3))
    (using-os ?os-name)
    ?os-fact <- (os-facts
        (name ?os-name)
        (min-ram-gb ?os-min-ram)
        (rec-ram-gb ?os-rec-ram)
        (min-disk-gb ?os-min-disk)
        (rec-disk-gb ?os-rec-disk)
        (min-vram-gb ?os-min-vram)
        (rec-vram-gb ?os-rec-vram)
        (gpu-api-versions $?os-gpu-apis))
    =>
    (assert (os-ram-requirements
        (min-ram-gb ?os-min-ram)
        (rec-ram-gb ?os-rec-ram)))
    (assert (os-disk-requirements
        (min-disk-gb ?os-min-disk)
        (rec-disk-gb ?os-rec-disk)))
    (assert (os-gpu-requirements
        (min-vram-gb ?os-min-vram)
        (rec-vram-gb ?os-rec-vram)
        (gpu-api-versions $?os-gpu-apis)))
    (retract ?os-fact)
)

; Remove facts about other OSes that are not selected
(defrule remove-unselected-os-facts
    (declare (salience 10))
    (using-os ?os-name)
    ?other-os-fact <- (os-facts (name ?other&~?os-name))
    =>
    (retract ?other-os-fact)
)

; Remove facts about other software that are not compatible with the selected OS
(defrule remove-incompatible-software-facts
    (declare (salience 5))
    (using-os ?os-name)
    ?software-facts <- (software-facts
        (os-compatibility $?compatible-os))
    (test (not (member$ ?os-name ?compatible-os)))
    =>
    (retract ?software-facts)
)

; ===============================================
; Rules for software types requirements
; ===============================================

(defrule software-type-requirements
    (declare (salience 3))
    (using-software-type ?using-software-type-name)
    ?software-type <- (software-type-facts (type ?using-software-type-name))
    =>
    ; No specific requirements for software types in this implementation, but we could add some if needed.
    (retract ?software-type)
)

; Remove software type facts once software types have been selected
(defrule remove-unselected-software-type-facts
    (declare (salience 10))
    (exists (using-software-type ?any-selected-type))

    ?software-type-fact <- (software-type-facts (type ?software-type-name))
    (not (using-software-type ?software-type-name))
    =>
    (retract ?software-type-fact)
)

(defrule remove-software-facts-not-matching-selected-types
    (declare (salience 5))
   (exists (using-software-type ?any-selected-type))

   ?software-fact <- (software-facts (type ?software-type))
   (not (using-software-type ?software-type))
   =>
   (retract ?software-fact)
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

; GPU requirement template and cumulative fact
(deftemplate software-gpu-requirements-cumulative
    (slot min-vram-gb))

; Initialize cumulative requirements on startup
(defrule initialize-cumulative-requirements
    (not (software-ram-requirements-min))
    (not (software-disk-requirements-cumulative))
    (not (software-gpu-requirements-cumulative))
    =>
    (assert (software-ram-requirements-min
        (min-ram-gb 0)
        (rec-ram-gb 0)))
    (assert (software-disk-requirements-cumulative
        (total-storage-gb 0)))
    (assert (software-gpu-requirements-cumulative
        (min-vram-gb 0)))
)

; When a software is selected, update the cumulative RAM and disk requirements
(defrule software-requirements
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
    ?current-gpu <- (software-gpu-requirements-cumulative
        (min-vram-gb ?current-min-vram))
    =>
    ; Update cumulative storage requirement
    (retract ?current-storage)
    (assert (software-disk-requirements-cumulative
        (total-storage-gb (+ ?current-total ?storage-gb))))

    ; Update cumulative RAM requirement by taking the max of current and new requirements
    (retract ?current-ram)
    (assert (software-ram-requirements-min
        (min-ram-gb (max ?current-min-ram ?min-ram))
        (rec-ram-gb (max ?current-rec-ram ?rec-ram))))

    ; Update cumulative GPU requirement by taking the max of selected software VRAM needs
    (retract ?current-gpu)
    (assert (software-gpu-requirements-cumulative
        (min-vram-gb (max ?current-min-vram ?min-vram))))

    ; Retract the software fact and using-software fact since it's been processed.
    (retract ?using-software)
    (retract ?software-facts)
)

; ===============================================
; Done when no more software facts remain
; ===============================================

(defrule check-done
    (declare (salience -10))
    ; (not (software-facts))
    (not (using-software-type))
    =>
    (assert (done))
)


; ===============================================
; Calculate requirements
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

(deftemplate total-gpu-requirements
    (slot min-vram-gb)
    (slot rec-vram-gb)
    (multislot gpu-api-versions))

(defrule calculate-total-requirements
    ?done <- (done)
    (os-ram-requirements (min-ram-gb ?os-min-ram) (rec-ram-gb ?os-rec-ram))
    (os-disk-requirements (min-disk-gb ?os-min-disk) (rec-disk-gb ?os-rec-disk))
    (os-gpu-requirements (min-vram-gb ?os-min-vram) (rec-vram-gb ?os-rec-vram) (gpu-api-versions $?os-gpu-apis))
    (software-ram-requirements-min (min-ram-gb ?sw-min-ram) (rec-ram-gb ?sw-rec-ram))
    (software-disk-requirements-cumulative (total-storage-gb ?sw-storage))
    (software-gpu-requirements-cumulative (min-vram-gb ?sw-min-vram))
    =>
    (retract ?done)
    (assert (total-requirements
        (min-ram-gb (+ ?os-min-ram ?sw-min-ram))
        (rec-ram-gb (+ ?os-rec-ram ?sw-rec-ram))
        (min-disk-gb (+ ?os-min-disk ?sw-storage))
        (rec-disk-gb (+ ?os-rec-disk ?sw-storage))))
    (assert (total-gpu-requirements
        (min-vram-gb (+ ?os-min-vram ?sw-min-vram))
        (rec-vram-gb (+ ?os-rec-vram ?sw-min-vram))
        (gpu-api-versions $?os-gpu-apis)))
)
