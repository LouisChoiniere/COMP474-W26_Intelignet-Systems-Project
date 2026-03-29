(deftemplate os-facts
	(slot name)
	(slot min-ram-gb)
	(slot rec-ram-gb)
	(slot min-disk-gb)
	(slot rec-disk-gb)
	(slot min-vram-gb)
	(slot rec-vram-gb)
	(multislot gpu-graphics-api)
	(multislot gpu-api-versions))

(deftemplate software-type-facts
	(slot type))

(deftemplate software-facts
	(slot name)
	(slot type)
	(multislot os-compatibility)
	(slot min-ram-gb)
	(slot rec-ram-gb)
	(slot storage-gb)
	(slot min-vram-gb)
	(slot gpu-intensive)
	(slot directx-requirement))

(deffacts operating-system-facts
	; source: https://linuxvox.com/blog/linux-ubuntu-minimum-requirements/
	(os-facts
		(name linux)
		(min-ram-gb 2)
		(rec-ram-gb 4)
		(min-disk-gb 25)
		(rec-disk-gb 50)
		(min-vram-gb 0)
		(rec-vram-gb 2)
		(gpu-graphics-api vulkan opengl)
		(gpu-api-versions vulkan-1.3 opengl-4.6))

	; source: https://support.microsoft.com/en-us/windows/windows-10-system-requirements-6d4e9a79-66bf-7950-467c-795cf0386715
	(os-facts
		(name windows-10)
		(min-ram-gb 2)
		(rec-ram-gb 8)
		(min-disk-gb 20)
		(rec-disk-gb 64)
		(min-vram-gb 1)
		(rec-vram-gb 4)
        (gpu-graphics-api directx-9 directx-11)
        (gpu-api-versions directx-11 directx-9))

	; source: https://www.microsoft.com/en-us/windows/windows-11-specifications
	; source: https://support.microsoft.com/en-us/windows/windows-11-system-requirements-86c11283-ea52-4782-9efd-7674389a7ba3
	(os-facts
		(name windows-11)
		(min-ram-gb 4)
		(rec-ram-gb 8)
		(min-disk-gb 64)
		(rec-disk-gb 256)
		(min-vram-gb 2)
		(rec-vram-gb 8)
        (gpu-graphics-api directx-12 directx-11)
        (gpu-api-versions directx-12 directx-11))
)

(deffacts software-type-facts
	(software-type-facts (type development))
	(software-type-facts (type game))
	(software-type-facts (type application))
	(software-type-facts (type graphics))
)

(deffacts software-facts
	; source: https://learn.microsoft.com/en-us/visualstudio/releases/2022/system-requirements
	(software-facts
		(name visual-studio)
		(type development)
		(os-compatibility windows-10 windows-11)
		(min-ram-gb 4)
		(rec-ram-gb 16)
		(storage-gb 20)
		(min-vram-gb 0)
		(gpu-intensive no)
		(directx-requirement none))

	; source: https://www.jetbrains.com/help/idea/installation-guide.html
	(software-facts
		(name intellij-idea)
		(type development)
		(os-compatibility windows-10 windows-11 linux)
		(min-ram-gb 2)
		(rec-ram-gb 8)
		(storage-gb 5)
		(min-vram-gb 0)
		(gpu-intensive no)
		(directx-requirement none))

	; source: https://support.zoom.com/hc/en/article?id=zm_kb&sysparm_article=KB0060748#h_67509835-43ac-484f-9022-dca6a908b76a
	(software-facts
		(name zoom)
		(type application)
		(os-compatibility windows-10 windows-11 linux)
		(min-ram-gb 2)
		(rec-ram-gb 4)
		(storage-gb 1)
		(min-vram-gb 0)
		(gpu-intensive no)
		(directx-requirement none))

	; source: https://www.minecraft.net/en-us/store/minecraft-deluxe-collection-pc
	(software-facts
		(name minecraft)
		(type game)
		(os-compatibility windows-10 windows-11 linux)
		(min-ram-gb 2)
		(rec-ram-gb 4)
		(storage-gb 4)
		(min-vram-gb 1)
		(gpu-intensive yes)
		(directx-requirement directx-11))

	; source: https://www.epicgames.com/help/en-US/fortnite-battle-royale-c-202300000001636/technical-support-c-202300000001719/what-are-the-system-requirements-for-fortnite-on-pc-a202300000012731
	(software-facts
		(name fortnite)
		(type game)
		(os-compatibility windows-10 windows-11)
		(min-ram-gb 8)
		(rec-ram-gb 16)
		(storage-gb 30)
		(min-vram-gb 4)
		(gpu-intensive yes)
		(directx-requirement directx-12))

	; source: https://support-valorant.riotgames.com/hc/en-us/articles/360044136134-Minimum-Recommended-PC-Specs
	; source: https://www.eldorado.gg/blog/how-big-is-valorant/
	(software-facts
		(name valorant)
		(type game)
		(os-compatibility windows-10 windows-11)
		(min-ram-gb 4)
		(rec-ram-gb 4)
		(storage-gb 50)
		(min-vram-gb 2)
		(gpu-intensive yes)
		(directx-requirement directx-11))

	; source: https://helpx.adobe.com/photoshop/system-requirements/2024.html
	(software-facts
		(name photoshop)
		(type graphics)
		(os-compatibility windows-10 windows-11)
		(min-ram-gb 8)
		(rec-ram-gb 16)
		(storage-gb 20)
		(min-vram-gb 2)
		(gpu-intensive yes)
		(directx-requirement directx-12))

	; source: https://www.blender.org/download/requirements/
	(software-facts
		(name blender)
		(type graphics)
		(os-compatibility windows-10 windows-11 linux)
		(min-ram-gb 8)
		(rec-ram-gb 32)
		(storage-gb 2)
		(min-vram-gb 4)
		(gpu-intensive yes)
		(directx-requirement none))

	; source: https://dev.epicgames.com/documentation/en-us/unreal-engine/hardware-and-software-specifications-for-unreal-engine
	; source: https://thetechylife.com/how-many-gb-is-unreal/
	(software-facts
		(name unreal-engine)
		(type graphics)
		(os-compatibility windows-10 windows-11)
		(min-ram-gb 16)
		(rec-ram-gb 32)
		(storage-gb 100)
		(min-vram-gb 8)
		(gpu-intensive yes)
		(directx-requirement directx-12))

	; source: https://www.docker.com/products/docker-desktop
	(software-facts
		(name docker-desktop)
		(type development)
		(os-compatibility windows-10 windows-11)
		(min-ram-gb 2)
		(rec-ram-gb 4)
		(storage-gb 2)
		(min-vram-gb 0)
		(gpu-intensive no)
		(directx-requirement none))

	; source: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
	(software-facts
		(name kubernetes)
		(type development)
		(os-compatibility windows-10 windows-11 linux)
		(min-ram-gb 2)
		(rec-ram-gb 8)
		(storage-gb 1)
		(min-vram-gb 0)
		(gpu-intensive no)
		(directx-requirement none))

	; source: https://nodejs.org/en/download/package-manager
	(software-facts
		(name nodejs)
		(type development)
		(os-compatibility windows-10 windows-11 linux)
		(min-ram-gb 1)
		(rec-ram-gb 2)
		(storage-gb 0.2)
		(min-vram-gb 0)
		(gpu-intensive no)
		(directx-requirement none))

	; source: https://www.python.org/downloads/
	(software-facts
		(name python)
		(type development)
		(os-compatibility windows-10 windows-11 linux)
		(min-ram-gb 1)
		(rec-ram-gb 2)
		(storage-gb 0.1)
		(min-vram-gb 0)
		(gpu-intensive no)
		(directx-requirement none))

	; source: https://www.jetbrains.com/help/pycharm/installation-guide.html
	(software-facts
		(name pycharm)
		(type development)
		(os-compatibility windows-10 windows-11 linux)
		(min-ram-gb 4)
		(rec-ram-gb 8)
		(storage-gb 2.5)
		(min-vram-gb 0)
		(gpu-intensive no)
		(directx-requirement none))

	; source: https://support.microsoft.com/en-us/teams/teams-for-windows-system-requirements
	(software-facts
		(name microsoft-teams)
		(type application)
		(os-compatibility windows-10 windows-11)
		(min-ram-gb 2)
		(rec-ram-gb 4)
		(storage-gb 1)
		(min-vram-gb 0)
		(gpu-intensive no)
		(directx-requirement none))

	; source: https://discord.com/download
	(software-facts
		(name discord)
		(type application)
		(os-compatibility windows-10 windows-11 linux)
		(min-ram-gb 0.5)
		(rec-ram-gb 2)
		(storage-gb 0.5)
		(min-vram-gb 0)
		(gpu-intensive no)
		(directx-requirement none))

	; source: https://obsproject.com/wiki/Install-Instructions
	(software-facts
		(name obs-studio)
		(type application)
		(os-compatibility windows-10 windows-11 linux)
		(min-ram-gb 4)
		(rec-ram-gb 8)
		(storage-gb 0.3)
		(min-vram-gb 2)
		(gpu-intensive yes)
		(directx-requirement directx-11))

	; source: https://www.autodesk.com/products/maya/system-requirements
	(software-facts
		(name autodesk-maya)
		(type graphics)
		(os-compatibility windows-10 windows-11)
		(min-ram-gb 8)
		(rec-ram-gb 32)
		(storage-gb 12)
		(min-vram-gb 4)
		(gpu-intensive yes)
		(directx-requirement directx-12))

	; source: https://www.epicgames.com/help/en-us/fortnite-battle-royale-c-202300000001636/technical-support-c-202300000001719/what-are-the-system-requirements-for-fortnite-on-pc-a202300000012731
	(software-facts
		(name cyberpunk-2077)
		(type game)
		(os-compatibility windows-10 windows-11)
		(min-ram-gb 12)
		(rec-ram-gb 20)
		(storage-gb 120)
		(min-vram-gb 6)
		(gpu-intensive yes)
		(directx-requirement directx-12))

	; source: https://www.elden-ring.jp/en/
	(software-facts
		(name elden-ring)
		(type game)
		(os-compatibility windows-10 windows-11)
		(min-ram-gb 12)
		(rec-ram-gb 16)
		(storage-gb 60)
		(min-vram-gb 4)
		(gpu-intensive yes)
		(directx-requirement directx-12))

	; source: https://www.nvidia.com/geforce/rtx-voice/
	(software-facts
		(name nvidia-rtx-voice)
		(type application)
		(os-compatibility windows-10 windows-11)
		(min-ram-gb 1)
		(rec-ram-gb 2)
		(storage-gb 0.5)
		(min-vram-gb 1)
		(gpu-intensive yes)
		(directx-requirement directx-11))

	; source: https://www.adobe.com/products/premiere/system-requirements.html
	(software-facts
		(name adobe-premiere)
		(type graphics)
		(os-compatibility windows-10 windows-11)
		(min-ram-gb 8)
		(rec-ram-gb 32)
		(storage-gb 8)
		(min-vram-gb 4)
		(gpu-intensive yes)
		(directx-requirement directx-12))

	; source: https://www.affinity.serif.com/en-gb/designer/system-requirements/
	(software-facts
		(name affinity-designer)
		(type graphics)
		(os-compatibility windows-10 windows-11)
		(min-ram-gb 4)
		(rec-ram-gb 8)
		(storage-gb 1)
		(min-vram-gb 2)
		(gpu-intensive yes)
		(directx-requirement directx-11))

	; source: https://gfx.cs.princeton.edu/gfxtip/0021/index.html
	(software-facts
		(name blender-cycles-gpu)
		(type graphics)
		(os-compatibility windows-10 windows-11)
		(min-ram-gb 12)
		(rec-ram-gb 32)
		(storage-gb 2)
		(min-vram-gb 6)
		(gpu-intensive yes)
		(directx-requirement directx-12))

	; source: https://www.jetbrains.com/help/clion/installation-guide.html
	(software-facts
		(name clion)
		(type development)
		(os-compatibility windows-10 windows-11 linux)
		(min-ram-gb 4)
		(rec-ram-gb 8)
		(storage-gb 3)
		(min-vram-gb 0)
		(gpu-intensive no)
		(directx-requirement none))

	; source: https://code.visualstudio.com/docs/setup/linux
	(software-facts
		(name vscode)
		(type development)
		(os-compatibility windows-10 windows-11 linux)
		(min-ram-gb 1)
		(rec-ram-gb 4)
		(storage-gb 0.3)
		(min-vram-gb 0)
		(gpu-intensive no)
		(directx-requirement none))

	; source: https://www.gimp.org/downloads/
	(software-facts
		(name gimp)
		(type graphics)
		(os-compatibility windows-10 windows-11 linux)
		(min-ram-gb 1)
		(rec-ram-gb 4)
		(storage-gb 0.3)
		(min-vram-gb 0)
		(gpu-intensive no)
		(directx-requirement none))
)
