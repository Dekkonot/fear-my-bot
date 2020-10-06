---Returns the total number of elements in a table.
---
---This uses the global `pairs` function and respects `__pairs`.
---@param tbl table
---@return number
function table.count(tbl)

end

---Returns the total number of elements in a table, recursively.
---If a table is encountered, it is recursively counted instead of being directly added to the total count.
---
---This uses the global `pairs` function and respects `__pairs`.
---@param tbl table
---@return number
function table.deepcount(tbl)

end

---Returns a copy of the original table, one layer deep. Metatables are not copied.
---@param tbl table
---@return table
function table.copy(tbl)

end

---Returns a copy of the original table, recursively.
---If a table is encountered, it is recursively deep-copied. Metatables are not copied.
---@param tbl table
---@return table
function table.deepcopy(tbl)

end

---Reverses the elements of an array-like table in place.
---@param tbl table
function table.reverse(tbl)

end

---Returns a copy of an array-like table in place.
---The original table remains unchanged.
---@param tbl table
---@return table
function table.reversed(tbl)

end

---Returns a new array-like table where all of its values are the keys of the original table.
---@param tbl table
---@return table
function table.keys(tbl)

end

---Returns a new array-like table where all of its values are the values of the original table.
---@param tbl table
---@return table
function table.values(tbl)

end

---Returns a random (index, value) pair from an array-like table
---@param tbl table
---@return number
---@return any
function table.randomipair(tbl)

end

---Returns a random (key, value) pair from an dictionary-like table
---@param tbl table
---@return any
---@return any
function table.randomipair(tbl)

end

---Returns a copy of an array-like table sorted using Lua's table.sort
---@param tbl table
---@param fn function
---@return table
function table.sorted(tbl, fn)

end

---Iterates through a table until it finds a value that is equal to `value` according to the `==` operator.
---The key is returned if a match is found.
---@param tbl table
---@param value any
---@return any
function table.search(tbl, value)

end

---Returns a new table that is a slice of the original, defined by the start and stop bounds, and the step size.
---
---Default start, stop, and step values are `1`, `#tbl`, and `1`, respectively.
---@param tbl table
---@param start number
---@param stop number
---@param step number
---@return table
function table.slice(tbl, start, stop, step)

end

---Splits a string into a table of specially delimited substrings.
---The default for `delim` is an empty string.
---@param str string
---@param delim string
---@return string[]
function string.split(str, delim)

end

---Retruns a new string with all whitespace removed from the left and right sides of the original string.
---@param str string
---@return string
function string.split(str)

end

---Returns a new string that is padded up to the desired length with `pattern`.
---The alignment, either `left`, `right`, or `center`, defines the placement of the original string.
---The default for `pattern` is a space.
---@param str string
---@param len number
---@param align string | "left" | "right" | "center"
---@param pattern string
---@return string
function string.pad(str, len, align, pattern)

end

---If `plain` is true, returns whether a string starts with the specified substring.
---Otherwise, returns whether a string starts with the specified pattern.
---@param str string
---@param pattern string
---@param plain boolean
---@return boolean
function string.startswith(str, pattern, plain)

end

---If `plain` is true, returns whether a string ends with the specified substring.
---Otherwise, returns whether a string ends with the specified pattern.
---@param str string
---@param pattern string
---@param plain boolean
---@return boolean
function string.endswith(str, pattern, plain)

end

---Returns the [Levenshtein Distance](https://en.wikipedia.org/wiki/Levenshtein_distance) between two strings.
---A higher number indicates a greater distance.
---@param str1 string
---@param str2 string
---@return number
function string.levenshtein(str1, str2)

end

---Returns a random string of random characters with the specified length.
---If provided, the `min` and `max` bounds cannot be outside the range [0, 255].
---
---Use `32` and `126` for printable ASCII characters.
---@param len number
---@param min number
---@param max number
---@return string
function string.random(len, min, max)

end

---Returns a number that is clamped between `min` and `max`.
---@param n number
---@param min number
---@param max number
---@return number
function math.clamp(n, min, max)

end

---Returns a number that is rounded to the nearest defined digit.
---Negative values can be used for higher order places, and the default for `digit` is `0`.
---@param n number
---@param digits number
---@return number
function math.round(n, digits)

end