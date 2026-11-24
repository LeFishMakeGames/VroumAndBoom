-- Export Compile Commands module for clangd support
require "ecc/ecc"

newoption
{
    trigger = "graphics",
    value = "OPENGL_VERSION",
    description = "version of OpenGL to build raylib against",
    allowed = {
        { "opengl11", "OpenGL 1.1"},
        { "opengl21", "OpenGL 2.1"},
        { "opengl33", "OpenGL 3.3"},
        { "opengl43", "OpenGL 4.3"},
        { "openges2", "OpenGL ES2"},
        { "openges3", "OpenGL ES3"},
        { "software", "OpenGL 1.1 Software Render"}
    },
    default = "opengl33"
}

newoption
{
    trigger = "backend",
    value = "BACKEND_TYPE",
    description = "Backend Platform to use",
    allowed = {
        { "glfw", "GLFW"},
        { "rgfw", "RGFW"},
        { "win32", "WIN32"},
    },
    default = "glfw"
}

newoption
{
    trigger = "wayland",
    value = "WAYLAND",
    description = "build for wayland",
    allowed = {
        { "off", "Off"},
        { "on", "On"}
    },
    default = "off"
}

function download_progress(total, current)
    local ratio = current / total;
    ratio = math.min(math.max(ratio, 0), 1);
    local percent = math.floor(ratio * 100);
    print("Download progress (" .. percent .. "%/100%)")
end

function check_raylib()
    os.chdir("external")
    if(os.isdir("raylib-master") == false) then
        if(not os.isfile("raylib-master.zip")) then
            print("Raylib not found, downloading from github")
            local result_str, response_code = http.download("https://github.com/raysan5/raylib/archive/refs/heads/master.zip", "raylib-master.zip", {
                progress = download_progress,
                headers = { "From: Premake", "Referer: Premake" }
            })
        end
        print("Unzipping to " ..  os.getcwd())
        zip.extract("raylib-master.zip", os.getcwd())
        os.remove("raylib-master.zip")
    end
    os.chdir("../")
end

function build_externals()
     print("calling externals")
     check_raylib()
end

function platform_defines()
     filter {"options:backend=glfw"}
        defines{"PLATFORM_DESKTOP"}

    filter {"options:backend=rgfw"}
        defines{"PLATFORM_DESKTOP_RGFW"}

    filter {"options:backend=win32"}
        defines{"PLATFORM_DESKTOP_WIN32"}

    filter {"options:graphics=opengl43"}
        defines{"GRAPHICS_API_OPENGL_43"}

    filter {"options:graphics=opengl33"}
        defines{"GRAPHICS_API_OPENGL_33"}

    filter {"options:graphics=opengl21"}
        defines{"GRAPHICS_API_OPENGL_21"}

    filter {"options:graphics=opengl11"}
        defines{"GRAPHICS_API_OPENGL_11"}

    filter {"options:graphics=openges3"}
        defines{"GRAPHICS_API_OPENGL_ES3"}

    filter {"options:graphics=openges2"}
        defines{"GRAPHICS_API_OPENGL_ES2"}

    filter {"options:graphics=software"}
        defines{"GRAPHICS_API_OPENGL_SOFTWARE"}

    filter {"system:macosx"}
        disablewarnings {"deprecated-declarations"}

    filter {"system:linux", "options:wayland=off"}
        defines {"_GLFW_X11"}

    filter {"system:linux", "options:wayland=on"}
        defines {"_GLFW_WAYLAND"}

    filter {}
end

-- if you don't want to download raylib, then set this to false, and set the raylib dir to where you want raylib to be pulled from, must be full sources.
downloadRaylib = true
raylib_dir = "external/raylib-master"

-- ============================================================
-- Chemins de tes libs (relatifs au dossier build/ où se trouve ce fichier)
-- A ADAPTER selon l'emplacement réel de tes dossiers.
-- ============================================================
cyclone_dir = "../Cyclone"            -- doit contenir include/ et src/
game_lib_dir = "../VroumAndBoomLib"   -- Game.cpp, Game.h
test_dir = "../Test"                  -- test.cpp

-- Réglages communs aux projets qui utilisent raylib (exe, tests)
function link_raylib_app()
    links {"raylib"}
    includedirs { raylib_dir .. "/src" }

    filter "action:vs*"
        dependson {"raylib"}
        links {"raylib.lib"}

    filter "system:windows"
        links {"winmm", "gdi32", "opengl32"}
        libdirs {"../bin/%{cfg.buildcfg}"}

    filter "system:linux"
        links {"pthread", "m", "dl", "rt"}

    filter {"system:linux", "options:wayland=off"}
        links {"X11"}

    filter {"system:linux", "options:wayland=on"}
        links {"wayland-client", "wayland-cursor", "wayland-egl", "xkbcommon"}

    filter "system:macosx"
        links {"OpenGL.framework", "Cocoa.framework", "IOKit.framework", "CoreFoundation.framework", "CoreAudio.framework", "CoreVideo.framework", "AudioToolbox.framework", "QuartzCore.framework"}

    filter {}
end

workspaceName = 'MyGame'
baseName = path.getbasename(path.getdirectory(os.getcwd()));

--if (baseName ~= 'raylib-quickstart') then
    workspaceName = baseName
--end

if (os.isdir('build_files') == false) then
    os.mkdir('build_files')
end

if (os.isdir('external') == false) then
    os.mkdir('external')
end

workspace (workspaceName)
    location "../"
    configurations { "Debug", "Release"}
    platforms { "x64", "x86", "ARM64"}

    defaultplatform ("x64")

    filter "configurations:Debug"
        defines { "DEBUG" }
        symbols "On"

    filter "configurations:Release"
        defines { "NDEBUG" }
        optimize "On"

    filter {"configurations:Release", "action:vs*"}
       linktimeoptimization "On"

    filter { "platforms:x64" }
        architecture "x86_64"

    filter { "platforms:ARM64" }
        architecture "ARM64"

    filter {}

    targetdir "bin/%{cfg.buildcfg}/"

if (downloadRaylib) then
    build_externals()
    end

    startproject(workspaceName)

    -- ========================================================
    -- Cyclone_Library : lib statique, sans modification du code
    -- ========================================================
    project "Cyclone_Library"
        kind "StaticLib"
        language "C++"
        cppdialect "C++20"
        location "../Cyclone_Library"
        targetdir "../bin/%{cfg.buildcfg}"
        objdir "../obj/Cyclone_Library/%{cfg.buildcfg}"

        files { cyclone_dir .. "/src/**.cpp", cyclone_dir .. "/include/**.h" }
        includedirs { cyclone_dir .. "/include" }

        filter "action:vs*"
            defines{"_CRT_SECURE_NO_WARNINGS"}
            characterset ("Unicode")
            buildoptions { "/Zc:__cplusplus" }
        filter{}

    -- ========================================================
    -- VroumAndBoomLib : lib statique du jeu (Cyclone + raylib)
    -- ========================================================
    project "VroumAndBoomLib"
        kind "StaticLib"
        language "C++"
        cppdialect "C++20"
        location "../VroumAndBoomLib"
        targetdir "../bin/%{cfg.buildcfg}"
        objdir "../obj/VroumAndBoomLib/%{cfg.buildcfg}"

        files { game_lib_dir .. "/**.cpp", game_lib_dir .. "/**.h", game_lib_dir .. "/**.hpp" }
        includedirs { game_lib_dir, cyclone_dir .. "/include", raylib_dir .. "/src" }
        links { "Cyclone_Library" }
        dependson { "raylib" }

        platform_defines()

        filter "action:vs*"
            defines{"_WINSOCK_DEPRECATED_NO_WARNINGS", "_CRT_SECURE_NO_WARNINGS"}
            characterset ("Unicode")
            buildoptions { "/Zc:__cplusplus" }
        filter{}

    -- ========================================================
    -- Exécutable du jeu
    -- ========================================================
    project (workspaceName)
        kind "ConsoleApp"
        location "../"
        targetdir "../bin/%{cfg.buildcfg}"

        filter {"system:windows", "configurations:Release", "action:gmake*"}
            kind "WindowedApp"
            buildoptions { "-Wl,--subsystem,windows" }

        filter {"system:windows", "configurations:Release", "action:vs*"}
            kind "WindowedApp"
            entrypoint "mainCRTStartup"

        filter "action:vs*"
            debugdir "$(SolutionDir)"

        filter {"action:gmake*"} -- Uncoment if you need to force StaticLib
--          buildoptions { "-static" }
        filter{}

        vpaths 
        {
            ["Header Files/*"] = { "../src/**.h",  "../src/**.hpp"},
            ["Source Files/*"] = {"../src/**.c", "src/**.cpp"},
            ["Windows Resource Files/*"] = {"../src/**.rc", "../src/**.ico"},
            ["Game Resource Files/*"] = {"../resources/**"},
        }
        
        files {"../src/**.c", "../src/**.cpp", "../src/**.h", "../src/**.hpp"}
        
        filter {"system:windows", "action:vs*"}
            files {"../src/*.rc", "../src/*.ico"}
            files {"../resources/**"}

        filter{}
        
        includedirs { "../src" }
        includedirs { "../include" }
        includedirs { game_lib_dir, cyclone_dir .. "/include" }

        links {"VroumAndBoomLib", "Cyclone_Library"}
        link_raylib_app()

        cdialect "C17"
        cppdialect "C++20"

        flags { "ShadowedVariables"}
        platform_defines()

        filter "action:vs*"
            defines{"_WINSOCK_DEPRECATED_NO_WARNINGS", "_CRT_SECURE_NO_WARNINGS"}
            characterset ("Unicode")
            buildoptions { "/Zc:__cplusplus" }

        filter "system:windows"
            defines{"_WIN32"}

        filter{}

    -- ========================================================
    -- Test : exécutable GoogleTest
    -- ========================================================
    project "Test"
        kind "ConsoleApp"
        language "C++"
        cppdialect "C++20"
        location "../Test"
        targetdir "../bin/%{cfg.buildcfg}"
        objdir "../obj/Test/%{cfg.buildcfg}"

        files { test_dir .. "/**.cpp", test_dir .. "/**.h" }
        includedirs { game_lib_dir, cyclone_dir .. "/include" }

        links { "VroumAndBoomLib", "Cyclone_Library" }
        link_raylib_app()
        platform_defines()

        filter "action:vs*"
            defines{"_WINSOCK_DEPRECATED_NO_WARNINGS", "_CRT_SECURE_NO_WARNINGS"}
            characterset ("Unicode")
            buildoptions { "/Zc:__cplusplus" }
            -- GoogleTest via NuGet : recopie ici le nom exact du package
            -- présent dans l'ancien Test/packages.config
            nuget { "Microsoft.googletest.v140.windesktop.msvcstl.static.rt-dyn:1.8.1.7" }
        filter{}

    project "raylib"
        kind "StaticLib"
    
        platform_defines()

        location "../"

        language "C"
        targetdir "../bin/%{cfg.buildcfg}"


        filter {"options:wayland=on"}
            defines {"GLFW_LINUX_ENABLE_WAYLAND=TRUE" }

        filter {"options:wayland=on", "system:linux"}
            local wl = "build/" .. raylib_dir .. "/src"
            local xml = wl .. "/external/glfw/deps/wayland/"
            local protocols = {
                "wayland", "xdg-shell", "xdg-decoration-unstable-v1", "viewporter",
                "relative-pointer-unstable-v1", "pointer-constraints-unstable-v1",
                "fractional-scale-v1", "xdg-activation-v1", "idle-inhibit-unstable-v1",
            }
            local cmds = { "@echo Generating Wayland protocols..." }
            for _, p in ipairs(protocols) do
                local out = (p == "wayland") and "wayland-client-protocol" or (p .. "-client-protocol")
                table.insert(cmds, "@wayland-scanner client-header " .. xml .. p .. ".xml " .. wl .. "/" .. out .. ".h")
                table.insert(cmds, "@wayland-scanner private-code " .. xml .. p .. ".xml " .. wl .. "/" .. out .. "-code.h")
            end
            prebuildcommands(cmds)
        filter {}

        filter "action:vs*"
            defines{"_WINSOCK_DEPRECATED_NO_WARNINGS", "_CRT_SECURE_NO_WARNINGS"}
            characterset ("Unicode")
            buildoptions { "/Zc:__cplusplus" }
        filter{}

        includedirs {raylib_dir .. "/src", raylib_dir .. "/src/external/glfw/include" }
        vpaths
        {
            ["Header Files"] = { raylib_dir .. "/src/**.h"},
            ["Source Files/*"] = { raylib_dir .. "/src/**.c"},
        }
        files {raylib_dir .. "/src/*.h", raylib_dir .. "/src/*.c"}

        removefiles {raylib_dir .. "/src/rcore_*.c"}

        filter { "system:macosx", "files:" .. raylib_dir .. "/src/rglfw.c" }
            compileas "Objective-C"

        filter{}