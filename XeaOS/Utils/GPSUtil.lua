Direction = {["north"] = 2, ["south"] = 4,["west"] = 1, ["east"] = 3}

function checkForModem()
    local modems = { peripheral.find("modem", function(name, modem)
        return modem.isWireless()
    end) }
    if #modems ~= 0 then
        return true
    else
        return false
    end
end

function getOrientation(can_break)
    if checkForModem() then
        for i= 1,4 do
            loc1 = vector.new(gps.locate(2, false))
            if not turtle.forward() then
                for j=1,6 do
                        if not turtle.forward() then
                            if can_break then
                                turtle.dig()
                            end
                    else break end
                end
            end
            loc2 = vector.new(gps.locate(2, false))
            heading = loc2 - loc1
            if heading ~= vector.new(0,0,0) then
                turtle.back()
                return ((heading.x + math.abs(heading.x) * 2) + (heading.z + math.abs(heading.z) * 3))
            else
                turtle.turnLeft()
            end
        end
        return false
    else 
        return false
    end
end

function computeOrientation(orientation)
    if orientation == 1 then
        return {["west"] = "front", ["south"] = "left", ["east"] = "back", ["north"] ="right"}
    elseif orientation == 4 then
        return {["west"] = "right", ["south"] = "front", ["east"] = "left", ["north"] ="back"}
    elseif orientation == 3 then
        return {["west"] = "back", ["south"] = "right", ["east"] = "front", ["north"] ="left"}
    elseif orientation == 2 then
        return {["west"] = "left", ["south"] = "back", ["east"] = "right", ["north"] ="front"}
    else
        return false
    end
end

function getOrientationName(orientation)
    if orientation == 1 then
        return "west"
    elseif orientation == 2 then
        return "north"
    elseif orientation == 3 then
        return "east"
    elseif orientation == 4 then
        return "south"
    end
end

function turnTo(currentOrientation,newOrientation)
    local currentOrientationN = Direction[currentOrientation]
    compass = computeOrientation(currentOrientationN)
    if compass[newOrientation] == "front" then
        return currentOrientationN
    elseif compass[newOrientation] == "left" then
        turtle.turnLeft()
        return Direction[newOrientation]
    elseif compass[newOrientation] == "right" then
        turtle.turnRight()
        return Direction[newOrientation]
    elseif compass[newOrientation] == "back" then
        for i =1,2 do
            turtle.turnLeft()
        end
        return Direction[newOrientation]
    end
end

return {Direction = Direction,checkForModem = checkForModem, getOrientation = getOrientation, getOrientationName = getOrientationName, turnTo = turnTo}