local GPSUtil = require("./utils/GPSUtil")
local turtleUtil = {}
maxRetry = 7
can_dig = false

function calcDistance(A,B)
    return B - A
end

function refuelTo(FuelNeeded)
    for i= 1, 16 do
        if turtle.getFuelLevel() >= FuelNeeded then
            return true
        end
        turtle.select(i)
        if turtle.refuel(0) then
            for i = 1, turtle.getItemCount() do
                turtle.refuel(1)
                if turtle.getFuelLevel() >= FuelNeeded then
                    return true
                end
            end
        end
    end
    return false
end

function MoveX(currentX,newX)
    if currentX > newX then
        orientation = GPSUtil.turnTo(GPSUtil.getOrientationName(orientation),"west")
        for i=1,calcDistance(newX,currentX) do
            if not turtle.forward() then
                if can_dig then
                    turtle.dig()
                end
                if not turtle.forward() then
                    return false
                end
            end
            retry = 0
        end
    else
        orientation = GPSUtil.turnTo(GPSUtil.getOrientationName(orientation),"east")
        for i=1,calcDistance(currentX,newX) do
            if not turtle.forward() then
                if can_dig then
                    turtle.dig()
                end
                if not turtle.forward() then
                    return false
                end
            end
        end
    end
    return true
end

function MoveY(currentY,newY)
    if currentY > newY then
        for i=1,calcDistance(newY,currentY) do
            if not turtle.down() then
                turtle.digDown()
                if not turtle.down() then
                    return false
                end
            end
        end
    else
        for i=1,calcDistance(currentY,newY) do
            if not turtle.up() then
                turtle.digUp()
                if not turtle.up() then
                    return false
                end
            end
        end
    end
    return true
end

function MoveZ(CurrentZ,newZ)
    if CurrentZ > newZ then
        orientation = GPSUtil.turnTo(GPSUtil.getOrientationName(orientation),"north")
        for i=1,calcDistance(newZ,CurrentZ) do
            if not turtle.forward() then
                if can_dig then
                    turtle.dig()
                end
                if not turtle.forward() then
                    return false
                end
            end
        end
    else
        orientation = GPSUtil.turnTo(GPSUtil.getOrientationName(orientation),"south")
        for i=1,calcDistance(CurrentZ,newZ) do
            if not turtle.forward() then
                if can_dig then
                    turtle.dig()
                end
                if not turtle.forward() then
                    return false
                end
            end
        end
    end
    return true
end

function calcFuelNeeded(startPos,endPos)
    return math.max(startPos,endPos) - math.min(startPos,endPos)
end

function turtleUtil.goToCoords(xNew,yNew,zNew)
    if not(GPSUtil.checkForModem()) then
        return false, "No wireless modem foud."
    end

    x,y,z = gps.locate()

    if x == nil or y == nil or z == nil then
        return false, "No GPS postion found."
    end
    
    if (xNew == x and yNew == y and zNew == z) then
        return true
    end

    local fuelNeeded = calcFuelNeeded(x,xNew) + calcFuelNeeded(y,yNew) + calcFuelNeeded(z,zNew) + 2

    if not(refuelTo(fuelNeeded)) then
        return false, "Not enough fuel."
    end

    orientation = GPSUtil.getOrientation()
    if not(orientation) then
        return false, "Orientation error."
    end

    if not MoveX(x,xNew) then
        return false,"Something went wrong while moving", gps.locate()
    end

    if not MoveZ(z,zNew) then
        return false,"Something went wrong while moving", gps.locate()
    end

    if not MoveY(y,yNew) then
        return false,"Something went wrong while moving", gps.locate()
    end
end

function relocate()
    if turtle.up() and retry <= 4 then
        if turtle.forward() then
            retry = 0
            turtle.forward()
        end
    else
        turtle.down()
        turtle.turnLeft()
        if turtle.forward() then
            turtle.turnRight()
            for i=1,2 do
                turtle.forward()
            end
            turtle.turnRight()
            if turtle.forward() then
                retry = 0
            end
            turtle.turnLeft()
        else
            for i=1,2 do
            turtle.turnRight()
            end
            turtle.forward()
            turtle.turnLeft()
            for i=1,2 do
                turtle.forward()
            end
            turtle.turnLeft()
            if turtle.forward() then
                retry = 0
            end
            turtle.turnRight()
        end
    end
    x,y,z = gps.locate()
end

function turtleUtil.goToCoordsForce(xNew,yNew,zNew)
    if not(GPSUtil.checkForModem()) then
        return false, "No wireless modem foud."
    end

    x,y,z = gps.locate()

    if x == nil or y == nil or z == nil then
        return false, "No GPS postion found."
    end
    
    if (xNew == x and yNew == y and zNew == z) then
        return true
    end

    local fuelNeeded = calcFuelNeeded(x,xNew) + calcFuelNeeded(y,yNew) + calcFuelNeeded(z,zNew) + 2 + 200

    if not(refuelTo(fuelNeeded)) then
        return false, "Not enough fuel."
    end

    orientation = GPSUtil.getOrientation(false)
    if orientation == false then
        orientation = GPSUtil.getOrientation(true)
    end
    if orientation == false then
        return false,"Orientation not found"
    end
    retry = 0
    while not MoveX(x,xNew) do
        if x == nil then
            return false,"Am Lost"
        end
        relocate()
        retry = retry + 1
        if retry == maxRetry then
            return false,"Something went wrong while moving", gps.locate()
        end
    end

    retry = 0
    while not MoveZ(z,zNew) do
        relocate()
        retry = retry + 1
        if retry == 5 then
            can_dig = true
        end
        if retry == maxRetry then
            return false,"Something went wrong while moving", gps.locate()
        end
    end

    if not MoveY(y,yNew) then
        return false,"Something went wrong while moving", gps.locate()
    end
end

return turtleUtil