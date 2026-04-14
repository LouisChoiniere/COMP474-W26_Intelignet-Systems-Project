(deftemplate user-computer
    (slot number-of-cores (type NUMBER))
    (slot ram-size (type NUMBER))
    (slot storage-gb)
    (slot gpu-memory (type NUMBER))
    (multislot directx-versions)
)

(deftemplate software-requirements
    (slot name)
    (slot type 
        (type SYMBOL)
        (allowed-values productivity game development-tool other))
    (slot cores-required (type NUMBER))
    (slot min-ram-gb (type NUMBER))
    (slot rec-ram-gb (type NUMBER))
    (slot storage-gb)
    (slot min-vram-gb (type NUMBER))
    (slot rec-vram-gb (type NUMBER))
    (slot gpu-intensive 
        (type SYMBOL)
        (allowed-values yes no))
    (slot directx-requirement ; directx-11, directx-12, or none
        (type SYMBOL)
        (allowed-values directx-11 directx-12 none))
)

(deftemplate using-software
    (slot name)
)

(deftemplate program-run
    (slot name)
)

(deftemplate missing-requirement
    (slot name
        (type SYMBOL)
    (allowed-values ram storage gpu-memory directx))
)

; ==================== Fuzzy Logic Templates for Software Compatibility ====================
(deftemplate computer-effectiveness
    0 100 percent
    (
        (low (z 0 50))
        (medium (s 25 75))
        (high (s 50 100))
    )
)

(deftemplate performance-gap-fuzzy
    0 100 percent
    (
        (no-upgrade-needed (z 0 50))
        (consider-upgrade (s 25 75))
        (upgrade-needed (s 50 100))
    )
)

(deftemplate need-for-upgrade
    ; (slot effectiveness (type FUZZY-VALUE computer-effectiveness))
    (slot performance-gap (type FUZZY-VALUE performance-gap-fuzzy))
)

; (deffacts test
;     (need-for-upgrade 
;         (performance-gap no-upgrade-needed)
;     )
; )