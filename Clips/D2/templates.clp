(deftemplate user-computer
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
    (slot min-ram-gb (type NUMBER))
    (slot rec-ram-gb (type NUMBER))
    (slot storage-gb)
    (slot min-vram-gb (type NUMBER))
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
        (allowed-values ram storage gpu-memory gpu-performance directx))
)