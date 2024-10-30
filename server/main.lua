local CurrentResourceName = "LGF_Utility"
local CurrentResourceVersion = GetResourceMetadata(CurrentResourceName, "version", 0) or "unknown"

function CheckVersion(repoName)
    local url = ('https://api.github.com/repos/%s/releases/latest'):format(repoName)

    PerformHttpRequest(url, function(errorCode, resultData, resultHeaders)
        if errorCode == 200 then
            local result = json.decode(resultData)

            if result and result.tag_name then
                local latestVersion = result.tag_name

                if CurrentResourceVersion ~= latestVersion then
                    print(("^0[^3UPDATE^0] %s is outdated! Current version: ^1%s^0, Latest version: ^6%s^0"):format(
                    CurrentResourceName, CurrentResourceVersion, latestVersion))
                    print(("^0[^3INFO^0] Please update to the latest version from the repository: ^6%s^0"):format(result
                    .html_url))
                else
                    print(("^0[^6INFO^0] %s is up to date! (^6%s^0)"):format(CurrentResourceName, CurrentResourceVersion))
                end
            else
                print("^0[^1ERROR^0] Unable to fetch version information.")
            end
        else
            print(("^0[^1ERROR^0] Failed to fetch the latest version information. HTTP error code: %d"):format(errorCode))
        end
    end, "GET")
end

AddEventHandler('onServerResourceStart', function(resourceName)
    if resourceName == CurrentResourceName then
        local repoName = string.format('ENT510/%s', CurrentResourceName)
        CheckVersion(repoName)
    end
end)

