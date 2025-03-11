--[[
  This script scans a chest below the robot, compares to the recipes contained in a recipe file,
  then calls a building script that crafts the corresponding miniaturazation field crafting recipe
  Recipes are from the mod "Compact Machines 3"
]]

-- Load required APIs
local component = require("component")
local sides = require("sides")
local robot = require("robot")
local colors = require("colors")
local rs = component.redstone
local inventory_controller = component.inventory_controller
-- robotmovement is a custom api I made
local rm = require("robotMovement")

-- recipes separated from this file because theyre uuh... BIG
-- there are also separate recipe files for compact machines and the other resources
local recipes = require("machineRecipes")
-- local recipes = require("materialRecipes") 


local chestSide = sides.down -- Change this to the side where the chest is located

-- Function to scan the chest and return its contents
local function scanChest(chestSide)
    local contents = {}
    for slot = 1, inventory_controller.getInventorySize(chestSide) do
        local stack = inventory_controller.getStackInSlot(chestSide, slot)
        if stack then
            table.insert(contents, {
                item = stack.name,
                quantity = stack.size,
                slot = slot
            })
        end
    end
    return contents
end


-- Function to check if a recipe can be crafted with the available items
local function canCraftRecipe(chestContents, recipe)
    local required = {}
    for _, ingredient in ipairs(recipe.ingredients) do
        required[ingredient.item] = ingredient.quantity
    end


    -- Check if we have enough of each item
    for _, slotData in ipairs(chestContents) do
        if required[slotData.item] then
            required[slotData.item] = required[slotData.item] - slotData.quantity
            if required[slotData.item] <= 0 then
                required[slotData.item] = nil
            end
        end
    end


    -- If all required items are satisfied, return true
    return next(required) == nil
end


-- Function to collect items for a recipe
local function collectItemsForRecipe(chestSide, recipe)
    local chestContents = scanChest(chestSide)
    if not canCraftRecipe(chestContents, recipe) then
        return false, "Not enough items to craft " .. recipe.name
    end


    -- Collect items for the recipe
    for _, ingredient in ipairs(recipe.ingredients) do
        local remaining = ingredient.quantity
        robot.select(ingredient.slot)
        for _, slotData in ipairs(chestContents) do
            if slotData.item == ingredient.item and remaining > 0 then
                local take = math.min(slotData.quantity, remaining)
                inventory_controller.suckFromSlot(chestSide, slotData.slot, take)
                remaining = remaining - take
            end
        end
    end


    return true, "Successfully collected items for " .. recipe.name
end

local function tryToCraft()
    local craftedAnything = false;
    for _, recipe in ipairs(recipes) do
        robot.select(1)
        local success, message = collectItemsForRecipe(chestSide, recipe)
        if success then
            print(message)

            -- If a recipe is crafting, it waits for it to finish + 1 second to start a new one
            while rs.getInput(sides.up) > 0 do os.sleep(1) end
            os.sleep(1)

            -- Aligning to start position, then calling the script to build the recipe
            rm.move('f', 3)
            recipe.builderScript()

            rm.move('b')
            robot.select(recipe.catalystSlot)
            robot.drop()

            -- Returning to chest
            rm.move('b', 2)
            craftedAnything = true

            robot.select(1)
        end
    end
    return craftedAnything
end

rs.setBundledOutput(sides.left, colors.green, 15)
while true do
    robot.select(1)

    -- Avoids running the (probably expensive) scan function when the chest is empty or doesnt have enough item
    if rs.getBundledInput(sides.left, colors.black) > 0 then
        while not tryToCraft() do os.sleep(1) end
    else
        os.sleep(5)
    end
end
