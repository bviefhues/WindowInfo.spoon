--- === WindowInfo ===
---
--- Display information on focussed window, it's application and it's screen.

require("hs.hotkey")
require("hs.window")
require("hs.application")
require("hs.spoons")
require("hs.pasteboard")
require("hs.inspect")
require("hs.fnutils")

local obj={}
obj.__index = obj

-- Metadata
obj.name = "WindowInfo"
obj.version = "0.0"
obj.author = "B Viefhues"
obj.homepage = "https://github.com/bviefhues/WindowInfo.spoon"
obj.license = "MIT - https://opensource.org/licenses/MIT"

function obj.show()
    local choices = {}
    local c = hs.chooser.new(function(choice)
        if choice then
            hs.pasteboard.setContents(choice["text"])
        else
            hs.alert.show("No text")
        end
    end)

    local w = hs.window.focusedWindow()
    if w then
        -- window
        local winsnapshot = w:snapshot()
        table.insert(choices, {
            text=w:title(), 
            subText="Window Title", 
            image=winsnapshot})
        table.insert(choices, {
            text=w:size()._w .. " x " .. w:size()._h, 
            subText="Window Size", 
            image=winsnapshot})
        table.insert(choices, {
            text="x=" .. w:frame()._x .. " y=" .. w:frame()._y .. 
                 " w=" .. w:frame()._w .. " h=" .. w:frame()._h, 
            subText="Window Frame", 
            image=winsnapshot})
        table.insert(choices, {
            text=w:role(), 
            subText="Window Role", 
            image=winsnapshot})
        table.insert(choices, {
            text=w:subrole(), 
            subText="Window Subrole", 
            image=winsnapshot})
        
        -- application
        local a = w:application()
        if a then
            appicon = hs.image.iconForFile(a:path())
            table.insert(choices, {
                text=a:name(), 
                subText="Application Name", 
                image=appicon})
            table.insert(choices, {
                text=a:title(), 
                subText="Application Title", 
                image=appicon})
            table.insert(choices, {
                text=a:bundleID(), 
                subText="Application bundleID", 
                image=appicon})
            table.insert(choices, {
                text=a:path(), 
                subText="Application Path", 
                image=appicon})
        end

        -- screen
        local s = w:screen()
        local screensnapshot = s:snapshot()
        if s then
            table.insert(choices, {
                text=s:name(),
                subText="Screen Name", 
                image=screensnapshot})
            table.insert(choices, {
                text="x=" .. s:frame()._x .. " y=" .. s:frame()._y .. 
                     " w=" .. s:frame()._w .. " h=" .. s:frame()._h, 
                subText="Screen Frame", 
                image=screensnapshot})
            table.insert(choices, {
                text="x=" .. s:fullFrame()._x .. " y=" .. s:fullFrame()._y .. 
                     " w=" .. s:fullFrame()._w .. " h=" .. s:fullFrame()._h, 
                subText="Screen Full Frame", 
                image=screensnapshot})
        end
    else
        hs.alert.show("No window")
    end
    c:choices(choices)
    c:rows(#choices)
    c:show() 
end


--- WindowInfo:bindHotkeys(mapping) -> self
--- Method
--- Binds hotkeys for WindowInfo
---
--- Parameters:
---  * mapping - A table containing hotkey modifier/key details for 
---    the following items:
---  * show - show window information chooser. Selecting an item in the
---    chooser copies the text to the pasteboard (clipboard)
---
--- Returns:
---  * The WindowInfo object
function obj:bindHotkeys(mapping)
    local def = {
        show = obj.show
    }
    hs.spoons.bindHotkeysToSpec(def, mapping)
    return self
end

return obj
