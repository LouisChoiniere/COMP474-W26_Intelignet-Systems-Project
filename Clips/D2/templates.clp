(deftemplate ram-size ; RAM size in GB
    0 128 gb
    (
        (xsmall (Z 4 5)) ; 4 gb is xsmall up to slightly below 5 gb
        (small (PI 4 8)) ; 8 gb +- 4 gb is small
        (medium (PI 4 12)) ; 12 gb +- 4 gb is medium
        (large (PI 10 32)) ; 32 gb +- 10 gb is large
        (xlarge (S 32 48)) ; 32 gb to inf is xlarge
    )
)

(deftemplate cpu-performance ; CPU performance from PassMark score (divided by 100)
    1 9999 points
    (
        (xsmall (Z 100 150)) ; 100 is xsmall up to slightly below 1500
        (small (PI 100 200)) ; 200 +- 100 is small
        (medium (PI 100 300)) ; 300 +- 100 is medium
        (large (PI 200 500)) ; 500 +- 200 is large
        (xlarge (S 500 1000)) ; 500 to inf is xlarge
    )
)

(deftemplate gpu-memory ; GPU memory size in GB
    0 32 gb
    (
        (xsmall (Z 1 2)) ; 1 gb is xsmall up to slightly below 2 gb
        (small (PI 2 3)) ; 2 gb +- 1 gb is small
        (medium (PI 2 6)) ; 6 gb +- 2 gb is medium
        (large (PI 4 10)) ; 10 gb +- 4 gb is large
        (xlarge (S 10 11)) ; 10 gb to inf is xlarge
    )
)

(deftemplate gpu-performance ; Pixel rate performance in GPixel/s
    0 999 GPixel 
    (
        (none (0 1) (1 0))
        (xsmall (Z 50 75))
        (small (PI 30 100))
        (medium (PI 25 150))
        (large (PI 50 200))
        (xlarge (S 200 300))
    )
)


(deftemplate user-computer
    (slot ram-size (type FUZZY-VALUE ram-size))
    (slot cpu-performance (type FUZZY-VALUE cpu-performance))
    (slot storage-gb)
    (slot gpu-memory (type FUZZY-VALUE gpu-memory))
    (slot gpu-performance (type FUZZY-VALUE gpu-performance))
    (multislot directx-versions)
)

(deftemplate software-requirements
    (slot name)
    (slot min-ram-gb (type FUZZY-VALUE ram-size))
    (slot rec-ram-gb (type FUZZY-VALUE ram-size))
    (slot storage-gb)
    (slot min-vram-gb (type FUZZY-VALUE gpu-memory))
    (slot gpu-intensive 
        (type SYMBOL)
        (allowed-values yes no))
    (slot gpu-performance (type FUZZY-VALUE gpu-performance))
    (slot directx-requirement ; directx-11, directx-12, or none
        (type SYMBOL)
        (allowed-values directx-11 directx-12 none))
)

(deftemplate using-software
    (slot name)
)