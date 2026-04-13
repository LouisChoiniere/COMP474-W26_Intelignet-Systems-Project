(deffacts using-software-facts
    (using-software (name minecraft))
    (using-software (name valorant))
    (using-software (name vscode))
    (using-software (name nodejs))
    (using-software (name python))
    (using-software (name spotify))
    (using-software (name cyberpunk-2077))
)

(deffacts initial-facts
    (user-computer 
        (ram-size small)
        (cpu-performance medium)
        (storage-gb 256)
        (gpu-memory small)
        (gpu-performance small)
        (directx-versions directx-11 directx-12))
)

