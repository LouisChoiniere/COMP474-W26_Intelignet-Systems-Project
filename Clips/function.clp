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

; Function to parse comma-separated input and return a multifield value
(deffunction parse-comma-separated (?input)
    (bind ?result (create$))
    (bind ?start 1)
    (bind ?len (str-length ?input))
    (bind ?i 1)
    
    (while (<= ?i ?len)
        (bind ?char (sub-string ?i ?i ?input))
        (if (or (eq ?char ",") (eq ?i ?len)) then
            (bind ?end (if (eq ?i ?len) then ?i else (- ?i 1)))
            (if (> ?end (- ?start 1)) then
                (bind ?token (sub-string ?start ?end ?input))
                ; Trim leading spaces
                (while (and (> (str-length ?token) 0) (eq (sub-string 1 1 ?token) " "))
                    (bind ?token (sub-string 2 (str-length ?token) ?token)))
                ; Trim trailing spaces
                (while (and (> (str-length ?token) 0) (eq (sub-string (str-length ?token) (str-length ?token) ?token) " "))
                    (bind ?token (sub-string 1 (- (str-length ?token) 1) ?token)))
                ; Add to result if not empty
                (if (> (str-length ?token) 0) then
                    (bind ?result (insert$ ?result (+ (length$ ?result) 1) (sym-cat ?token))))
            )
            (bind ?start (+ ?i 1))
        )
        (bind ?i (+ ?i 1))
    )
    
    (return ?result)
)
