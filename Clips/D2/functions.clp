(deffunction ask-user-computer-facts ()
    (printout t crlf "Enter your computer facts:" crlf)

    (printout t "Number of cores: ")
    (bind ?cores (read))

    (printout t "RAM size (GB): ")
    (bind ?ram (read))

    (printout t "Storage size (GB): ")
    (bind ?storage (read))

    (printout t "GPU memory (GB): ")
    (bind ?gpu (read))

    (printout t "DirectX versions (e.g., directx-11): ")
    (bind ?dx-line (read))
    ; (bind ?dx-versions (explode$ ?dx-line))

    (assert (user-computer
        (number-of-cores ?cores)
        (ram-size ?ram)
        (storage-gb ?storage)
        (gpu-memory ?gpu)
        (directx-versions directx-11)))
)
