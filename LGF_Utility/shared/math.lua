LGF.math = {}

function LGF.math:findMin(...)
    local args = { ... }

    if #args == 0 then
        return nil, "No arguments provided"
    end

    local minValue = args[1]

    for i = 2, #args do
        if args[i] < minValue then
            minValue = args[i]
        end
    end

    return minValue
end

function LGF.math:findMax(...)
    local args = { ... }

    if #args == 0 then
        return nil, "No arguments provided"
    end

    local maxValue = args[1]

    for i = 2, #args do
        if args[i] > maxValue then
            maxValue = args[i]
        end
    end

    return maxValue
end


function LGF.math:round(value, decimalPlaces)
    assert(type(value) == "number", "Value must be a number")
    decimalPlaces = decimalPlaces or 0
    local multiplier = 10 ^ decimalPlaces
    return math.floor(value * multiplier + 0.5) / multiplier
end

-- print(LGF.math:round(23.4234324324, 4)) 