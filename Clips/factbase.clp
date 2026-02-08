(deftemplate os-fact
	(slot name)
	(slot min-ram-gb)
	(slot recommended-ram-gb)
	(slot min-disk-gb)
	(slot recommended-disk-gb)
    (slot gpu-graphis-api))

(deftemplate software-fact
	(slot name)
	(slot type)
	(slot min-ram-gb)
	(slot recommended-ram-gb)
	(slot min-disk-gb))

(deffacts operating-system-facts
	(os-fact
		(name linux)
		(min-ram-gb 2)
		(recommended-ram-gb 4)
		(min-disk-gb 25)
		(recommended-disk-gb 50))

	(os-fact
		(name windows-10)
		(min-ram-gb 2)
		(recommended-ram-gb 8)
		(min-disk-gb 20)
		(recommended-disk-gb 64)
        (gpu-graphis-api directx-9))

	(os-fact
		(name windows-11)
		(min-ram-gb 4)
		(recommended-ram-gb 8)
		(min-disk-gb 64)
		(recommended-disk-gb 128)
        (gpu-graphis-api directx-12))
    )

(deffacts software-facts
	(software-fact
		(name google-chrome)
		(type app)
		(min-ram-gb 2)
		(recommended-ram-gb 4)
		(min-disk-gb 1))

	(software-fact
		(name visual-studio-code)
		(type app)
		(min-ram-gb 2)
		(recommended-ram-gb 4)
		(min-disk-gb 1))

	(software-fact
		(name zoom)
		(type app)
		(min-ram-gb 2)
		(recommended-ram-gb 4)
		(min-disk-gb 1))

	(software-fact
		(name minecraft)
		(type game)
		(min-ram-gb 4)
		(recommended-ram-gb 8)
		(min-disk-gb 4))

	(software-fact
		(name fortnite)
		(type game)
		(min-ram-gb 8)
		(recommended-ram-gb 16)
		(min-disk-gb 30))

	(software-fact
		(name valorant)
		(type game)
		(min-ram-gb 4)
		(recommended-ram-gb 8)
		(min-disk-gb 20)))