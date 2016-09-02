--------------------------------------------------------------------------------
-- Mappings, lists and sets that describe various game relationships
-- Modified from Mote-Mappings.lua
--------------------------------------------------------------------------------

-------------------------
-- Elemental Mappings
-------------------------

-- Basic elements
elements = {}

elements.list = S{'Light','Dark','Fire','Ice','Wind','Earth','Lightning','Water'}

elements.weak_to = {
    ['Light']='Dark',
    ['Dark']='Light',
    ['Fire']='Ice',
    ['Ice']='Wind',
    ['Wind']='Earth',
    ['Earth']='Lightning',
    ['Lightning']='Water',
    ['Water']='Fire'}

elements.strong_to = {
    ['Light']='Dark',
    ['Dark']='Light',
    ['Fire']='Water',
    ['Ice']='Fire',
    ['Wind']='Ice',
    ['Earth']='Wind',
    ['Lightning']='Earth',
    ['Water']='Lightning'}


storms = S{"Aurorastorm", "Voidstorm", "Firestorm", "Sandstorm", "Rainstorm", "Windstorm", "Hailstorm", "Thunderstorm"}
elements.storm_of = {
    ['Light']="Aurorastorm",
    ['Dark']="Voidstorm",
    ['Fire']="Firestorm",
    ['Earth']="Sandstorm",
    ['Water']="Rainstorm",
    ['Wind']="Windstorm",
    ['Ice']="Hailstorm",
    ['Lightning']="Thunderstorm"}

spirits = S{"LightSpirit", "DarkSpirit", "FireSpirit", "EarthSpirit", "WaterSpirit", "AirSpirit", "IceSpirit", "ThunderSpirit"}
elements.spirit_of = {
    ['Light']="Light Spirit",
    ['Dark']="Dark Spirit",
    ['Fire']="Fire Spirit",
    ['Earth']="Earth Spirit",
    ['Water']="Water Spirit",
    ['Wind']="Air Spirit",
    ['Ice']="Ice Spirit",
    ['Lightning']="Thunder Spirit"}

runes = S{'Lux', 'Tenebrae', 'Ignis', 'Gelus', 'Flabra', 'Tellus', 'Sulpor', 'Unda'}
elements.rune_of = {
    ['Light']='Lux',
    ['Dark']='Tenebrae',
    ['Fire']='Ignis',
    ['Ice']='Gelus',
    ['Wind']='Flabra',
    ['Earth']='Tellus',
    ['Lightning']='Sulpor',
    ['Water']='Unda'}

-- Elements for skillchain names
skillchain_elements = {}
skillchain_elements.Light = S{'Light','Fire','Wind','Lightning'}
skillchain_elements.Darkness = S{'Dark','Ice','Earth','Water'}
skillchain_elements.Fusion = S{'Light','Fire'}
skillchain_elements.Fragmentation = S{'Wind','Lightning'}
skillchain_elements.Distortion = S{'Ice','Water'}
skillchain_elements.Gravitation = S{'Dark','Earth'}
skillchain_elements.Transfixion = S{'Light'}
skillchain_elements.Compression = S{'Dark'}
skillchain_elements.Liquification = S{'Fire'}
skillchain_elements.Induration = S{'Ice'}
skillchain_elements.Detonation = S{'Wind'}
skillchain_elements.Scission = S{'Earth'}
skillchain_elements.Impaction = S{'Lightning'}
skillchain_elements.Reverberation = S{'Water'}

--------------------------------------------------------------------------------
-- Mappings for weaponskills
--------------------------------------------------------------------------------

-- REM weapons and their corresponding weaponskills
data = {}
data.weaponskills = {}
data.weaponskills.relic = {
    ["Spharai"] = "Final Heaven",
    ["Mandau"] = "Mercy Stroke",
    ["Excalibur"] = "Knights of Round",
    ["Ragnarok"] = "Scourge",
    ["Guttler"] = "Onslaught",
    ["Bravura"] = "Metatron Torment",
    ["Apocalypse"] = "Catastrophe",
    ["Gungnir"] = "Gierskogul",
    ["Kikoku"] = "Blade: Metsu",
    ["Amanomurakumo"] = "Tachi: Kaiten",
    ["Mjollnir"] = "Randgrith",
    ["Claustrum"] = "Gates of Tartarus",
    ["Annihilator"] = "Coronach",
    ["Yoichinoyumi"] = "Namas Arrow"}

data.weaponskills.mythic = {
    ["Conqueror"] = "King's Justice",
    ["Glanzfaust"] = "Ascetic's Fury",
    ["Yagrush"] = "Mystic Boon",
    ["Laevateinn"] = "Vidohunir",
    ["Murgleis"] = "Death Blossom",
    ["Vajra"] = "Mandalic Stab",
    ["Burtgang"] = "Atonement",
    ["Liberator"] = "Insurgency",
    ["Aymur"] = "Primal Rend",
    ["Carnwenhan"] = "Mordant Rime",
    ["Gastraphetes"] = "Trueflight",
    ["Kogarasumaru"] = "Tachi: Rana",
    ["Nagi"] = "Blade: Kamu",
    ["Ryunohige"] = "Drakesbane",
    ["Nirvana"] = "Garland of Bliss",
    ["Tizona"] = "Expiacion",
    ["Death Penalty"] = "Leaden Salute",
    ["Kenkonken"] = "Stringing Pummel",
    ["Terpsichore"] = "Pyrrhic Kleos",
    ["Tupsimati"] = "Omniscience",
    ["Idris"] = "Exudation",
    ["Epeolatry"] = "Dimidiation"}

data.weaponskills.empyrean = {
    ["Verethragna"] = "Victory Smite",
    ["Twashtar"] = "Rudra's Storm",
    ["Almace"] = "Chant du Cygne",
    ["Caladbolg"] = "Torcleaver",
    ["Farsha"] = "Cloudsplitter",
    ["Ukonvasara"] = "Ukko's Fury",
    ["Redemption"] = "Quietus",
    ["Rhongomiant"] = "Camlann's Torment",
    ["Kannagi"] = "Blade: Hi",
    ["Masamune"] = "Tachi: Fudo",
    ["Gambanteinn"] = "Dagan",
    ["Hvergelmir"] = "Myrkr",
    ["Gandiva"] = "Jishnu's Radiance",
    ["Armageddon"] = "Wildfire"}

data.weaponskills.ergon = {
    ["Idris"] = "Exudation",
    ["Epeolatry"] = "Dimidiation"}

data.weaponskills.aeonic = {
    ["Godhands"] = "Shijin Spiral",
    ["Aeneas"] = "Exenterator",
    ["Sequence"] = "Requiescat",
    ["Lionheart"] = "Resolution",
    ["Tri-edge"] = "Ruinator",
    ["Chango"] = "Upheaval",
    ["Anguta"] = "Entropy",
    ["Trishula"] = "Stardiver",
    ["Heishi Shorinken"] = "Blade: Shun",
    ["Dojikiri Yasutsuna"] = "Tachi: Shoha",
    ["Tishtrya"] = "Realmrazer",
    ["Khatvanga"] = "Shattersoul",
    ["Fail-Not"] = "Apex Arrow",
    ["Fomalhaut"] = "Last Stand"}

-- Weaponskills that can be used at range.
data.weaponskills.ranged = S{
    "Flaming Arrow", "Piercing Arrow", "Dulling Arrow", "Sidewinder",
    "Arching Arrow", "Empyreal Arrow", "Refulgent Arrow", "Apex Arrow",
    "Namas Arrow", "Jishnu's Radiance", "Hot Shot", "Split Shot", "Sniper Shot",
    "Slug Shot", "Heavy Shot", "Detonator", "Last Stand", "Coronach",
    "Trueflight", "Leaden Salute", "Wildfire", "Myrkr"}

ranged_weaponskills = data.weaponskills.ranged
