local mod = FHAC

local menuProvider = {}

--[[function menuProvider.SaveSaveData()
    mod.StoreSaveData()
end

function menuProvider.GetPaletteSetting()
    return mod.LoadSaveData().MenuPalette
end

function menuProvider.SavePaletteSetting(var)
    mod.LoadSaveData().MenuPalette = var
end

function menuProvider.GetHudOffsetSetting()
    if not REPENTANCE then
        return mod.LoadSaveData().HudOffset
    else
        return Options.HUDOffset * 10
    end
end

function menuProvider.SaveHudOffsetSetting(var)
    if not REPENTANCE then
        mod.LoadSaveData().HudOffset = var
    end
end

function menuProvider.GetGamepadToggleSetting()
    return mod.LoadSaveData().GamepadToggle
end

function menuProvider.SaveGamepadToggleSetting(var)
    mod.LoadSaveData().GamepadToggle = var
end

function menuProvider.GetMenuKeybindSetting()
    return mod.LoadSaveData().MenuKeybind
end

function menuProvider.SaveMenuKeybindSetting(var)
    mod.LoadSaveData().MenuKeybind = var
end

function menuProvider.GetMenuHintSetting()
    return mod.LoadSaveData().MenuHint
end

function menuProvider.SaveMenuHintSetting(var)
    mod.LoadSaveData().MenuHint = var
end

function menuProvider.GetMenuBuzzerSetting()
    return mod.LoadSaveData().MenuBuzzer
end

function menuProvider.SaveMenuBuzzerSetting(var)
    mod.LoadSaveData().MenuBuzzer = var
end

function menuProvider.GetMenusNotified()
    return mod.LoadSaveData().MenusNotified
end

function menuProvider.SaveMenusNotified(var)
    mod.LoadSaveData().MenusNotified = var
end

function menuProvider.GetMenusPoppedUp()
    return mod.LoadSaveData().MenusPoppedUp
end

function menuProvider.SaveMenusPoppedUp(var)
    mod.LoadSaveData().MenusPoppedUp = var
end

local DSSInitializerFunction = include("scripts.iam.deadseascrolls.dssmenucore")
local dssModName = "Hope (Teasrer)"
local dssCoreVersion = 7
local dssMod = DSSInitializerFunction(dssModName, dssCoreVersion, menuProvider)
local directory = {}
directory = {
    main = {
    title = "hope (teasrer)",
    buttons = {
            -- The str tag defines the text our button will show
            {str = 'resume game', action = 'resume'},
            {str = 'options', dest = 'options'},
            {str = "unlocks", dest = "unlocks", cursoroff = Vector(6, 0)},
			{str = 'difficulty', dest = 'diff'},
            {str = 'credits', dest = 'credits'},
            dssMod.changelogsButton,
            {str = '', fsize = 2, nosel = true},
            {str = 'this mod is still', fsize = 2, nosel = true},
            {str = 'in early development', fsize = 2, nosel = true},
            {str = 'a lot of buttons n stuff', fsize = 2, nosel = false},
            {str = 'isnt implemented', fsize = 2, nosel = true},
            {str = '', fsize = 2, nosel = true}
        },
        mod.changelogsButton,
    },
    tooltip = mod.menuOpenToolTip
    }
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--put settings here
directory.settings = {
    title = "settings",

    buttons = {
        {
            str = "arbitrary switch",

            -- choices is a list of strings that are the different choices for your button
            choices = {"on", "off"},

            -- setting is the index of the choice the player has selected
            -- We set it to 1 so that the default option is "on"
            -- This tag will update depending on what choice the player has selected
            setting = 1,

            -- variable is what DSS uses to store the state of the button
            -- Set it to any arbitrary string, just make sure that it is unique
            variable = "arbitraryChoiceOption",

            -- When the menu is opened, "load" will be called on all settings-buttons
            -- This function should return what the button's current setting should be
            -- This generall means loading whatever data you have stored for the setting
            load = function ()
                -- If we have no data, it'll return 1 because of the "or"
                return mod.GetDssData().SwitchState or 1
            end,

            -- When the menu is closed, "store" will be called on all settings-buttons
            -- This function should save the button's current setting
            -- The button's current setting is passed as the first argument
            store = function (var)
                mod.GetDssData().SwitchState = var
            end,

            tooltip = {strset = {"which do you", "prefer?"}}
        },
        
        -- These are the settings found on the outermost menu of DSS
        -- They'll only be visible in your menu if it is the only one active
        -- You should put them somewhere in your menu
        mod.gamepadToggleButton,
        mod.menuKeybindButton,
        mod.paletteButton,
        mod.menuHintButton,
        mod.menuBuzzerButton,
    }
}
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local directoryKey = {
    Item = directory.main, -- This is the initial item of the menu, generally you want to set it to your main item
    Main = 'main', -- The main item of the menu is the item that gets opened first when opening your mod's menu.

    -- These are default state variables for the menu; they're important to have in here, but you don't need to change them at all.
    Idle = false,
    MaskAlpha = 1,
    Settings = {},
    SettingsChanged = false,
    Path = {},
}

DeadSeaScrollsMenu.AddMenu("Hope (Teasrer)", {
    -- The Run, Close, and Open functions define the core loop of your menu
    -- Once your menu is opened, all the work is shifted off to your mod running these function
    -- This allows each mod to have its own independently functioning menu.

    -- The DSSInitializerFunction returns a table with defaults defined for each function
    -- These default functions are good enough for most mods
    -- If you do want a completely custom menu, making own functions is the way to do it
    
    -- This function runs every render frame while your menu is open
    -- It handles everything
    Run = dssMod.runMenu,

    -- This function runs when the menu is opened
    -- Generally it initializes the menu
    Open = dssMod.openMenu,

    -- This function runs when the menu is closed
    -- Generally it handles the storing of save data and general shutdown logic.
    Close = dssMod.closeMenu,

    -- This will hide your mod behind an "other mods" button if enabled
    -- It only activates if other mods with DSS are enabled
    -- It's a good idea to enable this if you don't expect players to use your menu often
    UseSubMenu = false,

    Directory = directory,
    DirectoryKey = directoryKey
})]]