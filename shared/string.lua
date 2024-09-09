LGF.string = {}

_G.GENERATEDSTRING = {}

function LGF.string:RandStr(len, patt, limit)
    limit = limit or 100
    assert(type(patt) == "string", "Pattern must be a string.")
    assert(len > 0 and len <= limit, ("Length must be a positive number and less than or equal to %d."):format(limit))

    local charsets = {
        aln = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",
        num = "0123456789",
        alp = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
        hex = "abcdef0123456789",
        upp = "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
        low = "abcdefghijklmnopqrstuvwxyz",
    }

    local chars = charsets[patt] or charsets.aln

    local GenerateUniqueString = function()
        local str = {}

        for i = 1, len do
            local idx = math.random(#chars)
            str[i] = chars:sub(idx, idx)
        end

        return table.concat(str)
    end

    local success, result

    LGF:SafeAsyncWait(100, function()
        repeat
            result = GenerateUniqueString()
        until not GENERATEDSTRING[result]
        _G.GENERATEDSTRING[result] = true
        success = true
    end)

    if success then
        return result
    else
        return nil
    end
end

function LGF.string:ToLower(str)
    assert(type(str) == "string", "Input must be a string")
    return str:lower()
end

function LGF.string:TrimSpace(str)
    assert(type(str) == "string", "Input must be a string")
    return str:gsub("%s+", "")
end

function LGF.string:GetGeneratedString()
    return _G.GENERATEDSTRING
end

