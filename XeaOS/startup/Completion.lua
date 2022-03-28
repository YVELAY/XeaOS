local function completeMultipleChoice( sText, tOptions, bAddSpaces )
    local tResults = {}
    for n=1,#tOptions do
        local sOption = tOptions[n]
        if #sOption + (bAddSpaces and 1 or 0) > #sText and string.sub( sOption, 1, #sText ) == sText then
            local sResult = string.sub( sOption, #sText + 1 )
            if bAddSpaces then
                table.insert( tResults, sResult .. " " )
            else
                table.insert( tResults, sResult )
            end
        end
    end
    return tResults
end
local function completePeripheralName( sText, bAddSpaces )
    return completeMultipleChoice( sText, peripheral.getNames(), bAddSpaces )
end
local tRedstoneSides = redstone.getSides()
local function completeSide( sText, bAddSpaces )
    return completeMultipleChoice( sText, tRedstoneSides, bAddSpaces )
end
local function completeFile( shell, nIndex, sText, tPreviousText )
    if nIndex == 1 then
        return fs.complete( sText, shell.dir(), true, false )
    end
end
local function completeDir( shell, nIndex, sText, tPreviousText )
    if nIndex == 1 then
        return fs.complete( sText, shell.dir(), false, true )
    end
end
local function completeEither( shell, nIndex, sText, tPreviousText )
    if nIndex == 1 then
        return fs.complete( sText, shell.dir(), true, true )
    end
end
local function completeEitherEither( shell, nIndex, sText, tPreviousText )
    if nIndex == 1 then
        local tResults = fs.complete( sText, shell.dir(), true, true )
        for n=1,#tResults do
            local sResult = tResults[n]
            if string.sub( sResult, #sResult, #sResult ) ~= "/" then
                tResults[n] = sResult .. " "
            end
        end
        return tResults
    elseif nIndex == 2 then
        return fs.complete( sText, shell.dir(), true, true )
    end
end
local function completeProgram( shell, nIndex, sText, tPreviousText )
    if nIndex == 1 then
        return shell.completeProgram( sText )
    end
end
local function completeHelp( shell, nIndex, sText, tPreviousText )
    if nIndex == 1 then
        return help.completeTopic( sText )
    end
end
local function completeAlias( shell, nIndex, sText, tPreviousText )
    if nIndex == 2 then
        return shell.completeProgram( sText )
    end
end
local function completePeripheral( shell, nIndex, sText, tPreviousText )
    if nIndex == 1 then
        return completePeripheralName( sText )
    end
end
local tGPSOptions = { "host", "host ", "locate" }
local function completeGPS( shell, nIndex, sText, tPreviousText )
    if nIndex == 1 then
        return completeMultipleChoice( sText, tGPSOptions )
    end
end
local tLabelOptions = { "get", "get ", "set ", "clear", "clear " }
local function completeLabel( shell, nIndex, sText, tPreviousText )
    if nIndex == 1 then
        return completeMultipleChoice( sText, tLabelOptions )
    elseif nIndex == 2 then
        return completePeripheralName( sText )
    end
end
local function completeMonitor( shell, nIndex, sText, tPreviousText )
    if nIndex == 1 then
        return completePeripheralName( sText, true )
    elseif nIndex == 2 then
        return shell.completeProgram( sText )
    end
end
local tRedstoneOptions = { "probe", "set ", "pulse " }
local function completeRedstone( shell, nIndex, sText, tPreviousText )
    if nIndex == 1 then
        return completeMultipleChoice( sText, tRedstoneOptions )
    elseif nIndex == 2 then
        return completeSide( sText )
    end
end
local tDJOptions = { "play", "play ", "stop " }
local function completeDJ( shell, nIndex, sText, tPreviousText )
    if nIndex == 1 then
        return completeMultipleChoice( sText, tDJOptions )
    elseif nIndex == 2 then
        return completePeripheralName( sText )
    end
end
local tPastebinOptions = { "put ", "get ", "run " }
local function completePastebin( shell, nIndex, sText, tPreviousText )
    if nIndex == 1 then
        return completeMultipleChoice( sText, tPastebinOptions )
    elseif nIndex == 2 then
        if tPreviousText[2] == "put" then
            return fs.complete( sText, shell.dir(), true, false )
        end
    end
end
local tChatOptions = { "host ", "join " }
local function completeChat( shell, nIndex, sText, tPreviousText )
    if nIndex == 1 then
        return completeMultipleChoice( sText, tChatOptions )
    end
end
local function completeSet( shell, nIndex, sText, tPreviousText )
    if nIndex == 1 then
        return completeMultipleChoice( sText, settings.getNames(), true )
    end
end
local tCommands 
if commands then
    tCommands = commands.list()
end
local function completeExec( shell, nIndex, sText, tPreviousText )
    if nIndex == 1 and commands then
        return completeMultipleChoice( sText, tCommands, true )
    end
end
shell.setCompletionFunction( "bin/alias.lua", completeAlias )
shell.setCompletionFunction( "bin/cd.lua", completeDir )
shell.setCompletionFunction( "bin/copy.lua", completeEitherEither )
shell.setCompletionFunction( "bin/delete.lua", completeEither )
shell.setCompletionFunction( "bin/drive.lua", completeDir )
shell.setCompletionFunction( "bin/edit.lua", completeFile )
shell.setCompletionFunction( "bin/eject.lua", completePeripheral )
shell.setCompletionFunction( "bin/gps.lua", completeGPS )
shell.setCompletionFunction( "bin/help.lua", completeHelp )
shell.setCompletionFunction( "bin/id.lua", completePeripheral )
shell.setCompletionFunction( "bin/label.lua", completeLabel )
shell.setCompletionFunction( "bin/list.lua", completeDir )
shell.setCompletionFunction( "bin/mkdir.lua", completeFile )
shell.setCompletionFunction( "bin/monitor.lua", completeMonitor )
shell.setCompletionFunction( "bin/move.lua", completeEitherEither )
shell.setCompletionFunction( "bin/redstone.lua", completeRedstone )
shell.setCompletionFunction( "bin/rename.lua", completeEitherEither )
shell.setCompletionFunction( "bin/shell.lua", completeProgram )
shell.setCompletionFunction( "bin/type.lua", completeEither )
shell.setCompletionFunction( "bin/set.lua", completeSet )
shell.setCompletionFunction( "bin/advanced/bg.lua", completeProgram )
shell.setCompletionFunction( "bin/advanced/fg.lua", completeProgram )
shell.setCompletionFunction( "bin/fun/dj.lua", completeDJ )
shell.setCompletionFunction( "bin/fun/advanced/paint.lua", completeFile )
shell.setCompletionFunction( "bin/http/pastebin.lua", completePastebin )
shell.setCompletionFunction( "bin/rednet/chat.lua", completeChat )
shell.setCompletionFunction( "bin/command/exec.lua", completeExec )