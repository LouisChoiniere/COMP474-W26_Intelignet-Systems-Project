(deftemplate os-facts
	(slot name)
	(slot min-ram-gb)
	(slot rec-ram-gb)
	(slot min-disk-gb)
	(slot rec-disk-gb)
    (slot gpu-graphics-api))

(deftemplate software-facts
	(slot name)
	(slot type)
	(slot os-compatibility)
	(slot min-ram-gb)
	(slot rec-ram-gb)
	(slot storage-gb))

(deffacts operating-system-facts
	; source: https://linuxvox.com/blog/linux-ubuntu-minimum-requirements/
	(os-facts
		(name linux)
		(min-ram-gb 2)
		(rec-ram-gb 4)
		(min-disk-gb 25)
		(rec-disk-gb 50))

	; source: https://support.microsoft.com/en-us/windows/windows-10-system-requirements-6d4e9a79-66bf-7950-467c-795cf0386715
	(os-facts
		(name windows-10)
		(min-ram-gb 2)
		(rec-ram-gb 8)
		(min-disk-gb 20)
		(rec-disk-gb 64)
        (gpu-graphics-api directx-9))

	; source: https://www.microsoft.com/en-us/windows/windows-11-specifications
	; source: https://support.microsoft.com/en-us/windows/windows-11-system-requirements-86c11283-ea52-4782-9efd-7674389a7ba3
	(os-facts
		(name windows-11)
		(min-ram-gb 4)
		(rec-ram-gb 8)
		(min-disk-gb 64)
		(rec-disk-gb 256)
        (gpu-graphics-api directx-12))
    )

(deffacts software-facts
	; source: https://learn.microsoft.com/en-us/visualstudio/releases/2022/system-requirements
	(software-facts
		(name visual-studio)
		(type development)
		(os-compatibility windows-10 windows-11)
		(min-ram-gb 4)
		(rec-ram-gb 16)
		(storage-gb 20))

	; source: https://www.jetbrains.com/help/idea/installation-guide.html
	(software-facts
		(name intellij-idea)
		(type development)
		(os-compatibility windows-10 windows-11 linux)
		(min-ram-gb 2)
		(rec-ram-gb 8)
		(storage-gb 5))

	; source: https://support.zoom.com/hc/en/article?id=zm_kb&sysparm_article=KB0060748#h_67509835-43ac-484f-9022-dca6a908b76a
	(software-facts
		(name zoom)
		(type application)
		(os-compatibility windows-10 windows-11 linux)
		(min-ram-gb 2)
		(rec-ram-gb 4)
		(storage-gb 1))

	; source: https://www.minecraft.net/en-us/store/minecraft-deluxe-collection-pc
	(software-facts
		(name minecraft)
		(type game)
		(os-compatibility windows-10 windows-11 linux)
		(min-ram-gb 2)
		(rec-ram-gb 4)
		(storage-gb 4))

	; source: https://www.epicgames.com/help/en-US/fortnite-battle-royale-c-202300000001636/technical-support-c-202300000001719/what-are-the-system-requirements-for-fortnite-on-pc-a202300000012731
	(software-facts
		(name fortnite)
		(type game)
		(os-compatibility windows-10 windows-11)
		(min-ram-gb 8)
		(rec-ram-gb 16)
		(storage-gb 30))

	; source: https://support-valorant.riotgames.com/hc/en-us/articles/360044136134-Minimum-Recommended-PC-Specs
	; source: https://www.eldorado.gg/blog/how-big-is-valorant/
	(software-facts
		(name valorant)
		(type game)
		(os-compatibility windows-10 windows-11)
		(min-ram-gb 4)
		(rec-ram-gb 4)
		(storage-gb 50))

	; source: https://helpx.adobe.com/photoshop/system-requirements/2024.html
	(software-facts
		(name photoshop)
		(type graphics)
		(os-compatibility windows-10 windows-11)
		(min-ram-gb 8)
		(rec-ram-gb 16)
		(storage-gb 20))

	; source: https://www.blender.org/download/requirements/
	(software-facts
		(name blender)
		(type graphics)
		(os-compatibility windows-10 windows-11 linux)
		(min-ram-gb 8)
		(rec-ram-gb 32)
		(storage-gb 2)

	; source: https://dev.epicgames.com/documentation/en-us/unreal-engine/hardware-and-software-specifications-for-unreal-engine
	; source: https://thetechylife.com/how-many-gb-is-unreal/
	(software-facts
		(name unreal-engine)
		(type graphics)
		(os-compatibility windows-10 windows-11)
		(min-ram-gb 16)
		(rec-ram-gb 32)
		(storage-gb 100))
)