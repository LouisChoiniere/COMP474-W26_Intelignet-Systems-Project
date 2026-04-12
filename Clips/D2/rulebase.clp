(defrule check-software-requirements
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
                    (cpu-performance ?cpu-performance)
                    (gpu-memory ?gpu-memory)
                    (gpu-performance ?gpu-performance))
=>
    (printout t "Checking if " ?sname " can run on the user's computer..." crlf)
)