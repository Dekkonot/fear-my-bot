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