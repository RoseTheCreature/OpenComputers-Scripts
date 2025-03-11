-- Recipes for all useful tiers of compact machines
local cubeBuilder = require("cubeBuilder")

local recipes = {
  {
    name = "Large Machine",
    ingredients = {
      { item = "compactmachines3:wallbreakable", quantity = 98 },
      { item = "minecraft:ender_pearl",          quantity = 1 },
      { item = "minecraft:dirt",                 quantity = 1 }
    },
    builderScript = cubeBuilder.craftBigCube,
    specialCube = true,
    catalystSlot = 3
  },
  {
    name = "Giant Machine",
    ingredients = {
      { item = "compactmachines3:wallbreakable", quantity = 20 },
      { item = "contenttweaker:glitched3",       quantity = 6 },
      { item = "modularmachinery:blockcasing",   quantity = 1 },
      { item = "minecraft:ender_pearl",          quantity = 1 }
    },
    builderScript = cubeBuilder.craftSpecialCube,
    specialCube = true,
    catalystSlot = 4
  },
  {
    name = "Max Machine",
    ingredients = {
      { item = "compactmachines3:wallbreakable", quantity = 20 },
      { item = "contenttweaker:glitched4",       quantity = 6 },
      { item = "modularmachinery:blockcasing",   quantity = 1 },
      { item = "minecraft:ender_pearl",          quantity = 1 }
    },
    builderScript = cubeBuilder.craftSpecialCube,
    specialCube = true,
    catalystSlot = 4
  },
  {
    name = "Normal Compact Machine",
    ingredients = {
      { item = "compactmachines3:wallbreakable", quantity = 26 },
      { item = "minecraft:gold_block",           quantity = 1 },
      { item = "minecraft:ender_pearl",          quantity = 1 }
    },
    builderScript = cubeBuilder.craftRegCube,
    catalystSlot = 3
  },
  {
    name = "Small Compact Machine",
    ingredients = {
      { item = "compactmachines3:wallbreakable", quantity = 26 },
      { item = "minecraft:iron_block",           quantity = 1 },
      { item = "minecraft:ender_pearl",          quantity = 1 }
    },
    builderScript = cubeBuilder.craftRegCube,
    catalystSlot = 3
  }
}

return recipes
