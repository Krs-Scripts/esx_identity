Config = {}
Config.Locale = GetConvar("esx:locale", "en")

-- [Config.EnableCommands]
-- Enables Commands Such As /char and /chardel
Config.EnableCommands = ESX.GetConfig().EnableDebug

-- These values are for the date format in the registration menu
-- Choices: DD/MM/YYYY | MM/DD/YYYY | YYYY/MM/DD
Config.DateFormat = "DD/MM/YYYY"

-- These values are for the second input validation in server/main.lua
Config.MaxNameLength = 20 -- Max Name Length.
Config.MinHeight = 120 -- 120 cm lowest height
Config.MaxHeight = 220 -- 220 cm max height.
Config.MaxAge = 100 -- 100 years old is the oldest you can be.

Config.FullCharDelete = true -- Delete all reference to character.
Config.EnableDebugging = ESX.GetConfig().EnableDebug -- prints for debugging :)

-- NUI colors, customizable
Config.Colors = {
    accent = '#00aaff',                        -- main color: icons, "Creator", male selected, submit button, calendar
    accentDark = '#0077ff',                    -- end of the main color's gradient
    accentGlow = 'rgba(0, 170, 255, 0.35)',    -- glow in the background corners (same color, more transparent)

    female = '#ff5fa2',                        -- female selected
    femaleDark = '#ff2d8e',                    -- end of the female gradient

    panelBgStart = 'rgba(12, 12, 12, 0.91)',   -- panel background, first gradient stop
    panelBgMid = 'rgba(15, 15, 15, 0.6)',      -- panel background, second gradient stop

    inputBg = 'rgba(0, 0, 0, 0.35)',           -- default background for inputs/icons/buttons
    inputBgFocus = 'rgba(0, 0, 0, 0.5)',       -- background on focus/hover

    calendarBg = 'rgba(18, 18, 18, 0.97)',     -- calendar popup background
}