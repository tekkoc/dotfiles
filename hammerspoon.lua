-- HANDLE SCROLLING

local deferred = false

overrideMiddleMouseDown = hs.eventtap.new({ hs.eventtap.event.types.middleMouseDown }, function(e)
    --print("down"))
    deferred = true
    return true
end)

overrideMiddleMouseUp = hs.eventtap.new({ hs.eventtap.event.types.middleMouseUp }, function(e)
    -- print("up"))
    if (deferred) then
        overrideMiddleMouseDown:stop()
        overrideMiddleMouseUp:stop()
        hs.eventtap.middleClick(e:location())
        overrideMiddleMouseDown:start()
        overrideMiddleMouseUp:start()
        return true
    end

    return false
end)


local oldmousepos = {}
local scrollmult = -4   -- negative multiplier makes mouse work like traditional scrollwheel
dragMiddleToScroll = hs.eventtap.new({ hs.eventtap.event.types.middleMouseDragged }, function(e)
    -- print("scroll");

    deferred = false

    oldmousepos = hs.mouse.getAbsolutePosition()    

    local dx = e:getProperty(hs.eventtap.event.properties['mouseEventDeltaX'])
    local dy = e:getProperty(hs.eventtap.event.properties['mouseEventDeltaY'])
    local scroll = hs.eventtap.event.newScrollEvent({dx * scrollmult, -dy * scrollmult},{},'pixel')

    -- put the mouse back
    hs.mouse.setAbsolutePosition(oldmousepos)

    return true, {scroll}
end)

overrideMiddleMouseDown:start()
overrideMiddleMouseUp:start()
dragMiddleToScroll:start()
