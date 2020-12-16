---@class Color
---@field b number
---@field g number
---@field r number
---@field value number

local Color = {
    -- [[Color Methods]] --

    ---Returns a new copy of the original color object.
    ---@param self Color
    ---@return Color
    copy = function(self) end,

    ---Sets the color's blue component.
    ---@param self Color
    ---@param b number
    setBlue = function(self, b) end,

    ---Sets the color's green component.
    ---@param self Color
    ---@param g number
    setGreen = function(self, g) end,

    ---Sets the color's red component.
    ---@param self Color
    ---@param r number
    setRed = function(self, r) end,

    ---Returns the hue, saturation, and lightness that represent the color value.
    ---@param self Color
    ---@return number
    ---@return number
    ---@return number
    toHSL = function(self) end,

    ---Returns the hue, saturation, and value that represent the color value.
    ---@param self Color
    ---@return number
    ---@return number
    ---@return number
    toHSV = function(self) end,

    ---Returns a 6-digit hexadecimal string that represents the color value.
    ---@param self Color
    ---@return string
    toHex = function(self) end,

    ---Returns the red, green, and blue values that are packed into the color value.
    ---@param self Color
    ---@return number
    ---@return number
    ---@return number
    toRGB = function(self) end,

    -- [[Color Static Functions]] --

    ---Constructs a new Color object from HSL values.
    ---Hue is allowed to overflow while saturation/lightness are clamped to [0, 1].
    ---@param h number
    ---@param s number
    ---@param l number
    ---@return Color
    fromHSL = function(h, s, l) end,

    ---Constructs a new Color object from HSV values.
    ---Hue is allowed to overflow while saturation/value are clamped to [0, 1].
    ---@param h number
    ---@param s number
    ---@param v number
    ---@return Color
    fromHSV = function(h, s, v) end,

    ---Constructs a new Color object from a hexadecimal string. The string may or may not be prefixed by `#`.
    ---@param hex string
    ---@return Color
    fromHex = function(hex) end,

    ---Constructs a new Color object from RGB values.
    ---Values are allowed to overflow, though it will not affect the actual color.
    ---@param r number
    ---@param g number
    ---@param b number
    ---@return Color
    fromRGB = function(r, g, b) end,
}

return Color