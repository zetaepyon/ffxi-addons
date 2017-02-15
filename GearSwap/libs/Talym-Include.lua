--packets = require('packets')
--require('maths')

-- Include various utility functions
include('Talym-Utility.lua')

-- Include visual job state display
include('Talym-StateDisplay.lua')

-- Include haste tracking functionality
include('haste-tracker.lua')

-- Define gear variable framework
function define_gear()

    gear.main = {}
    gear.sub = {}
    gear.ranged = {}
    gear.ammo = {}
    gear.head = {}
    gear.neck = {}
    gear.ear = {}
    gear.body = {}
    gear.hands = {}
    gear.ring = {}
    gear.back = {}
    gear.waist = {}
    gear.legs = {}
    gear.feet = {}

end

define_gear()
