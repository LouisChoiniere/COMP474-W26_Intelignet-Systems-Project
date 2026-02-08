; Function to round up to the nearest integer
(deffunction ceiling (?value)
    (bind ?q ?value)
    (bind ?i (integer ?q))
    (if (> ?q ?i) then (+ ?i 1) else ?i)
)

; Function to round RAM requirements up to the nearest standard size
(deffunction ram-rounded (?storage)
    (* (ceiling (/ ?storage 2.0)) 2)
)

; Function to round storage requirements up to the nearest standard size
(deffunction disk-rounded (?storage)
    (if (<= ?storage 0) then 0
    else (if (<= ?storage 64) then 64
    else (if (<= ?storage 128) then 128
    else (if (<= ?storage 512) then 512
    else (if (<= ?storage 1000) then 1000
    else (if (<= ?storage 2000) then 2000
    else (* (ceiling (/ ?storage 1000.0)) 1000)))))))
)
