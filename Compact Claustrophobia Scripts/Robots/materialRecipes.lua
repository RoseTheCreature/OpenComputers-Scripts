-- Recipes for materials and other random useful items
local cubeBuilder = require("cubeBuilder")
local miscbuilder = require("miscBuilder")

local recipes = {
  {
    name = "Ender Pearl",
    ingredients = {
      { item = "minecraft:obsidian",       quantity = 26 },
      { item = "minecraft:redstone_block", quantity = 1 },
      { item = "minecraft:redstone",       quantity = 1 }
    },
    builderScript = cubeBuilder.craftRegCube,
    catalystSlot = 3
  },
  {
    name = "Tunnels",
    ingredients = {
      { item = "compactmachines3:wallbreakable", quantity = 1 },
      { item = "minecraft:hopper",               quantity = 1 },
      { item = "minecraft:redstone",             quantity = 9 }
    },
    builderScript = miscbuilder.craftTunnel,
    catalystSlot = 3
  },
  {
    name = "Redstone Tunnels",
    ingredients = {
      { item = "compactmachines3:wallbreakable", quantity = 1 },
      { item = "minecraft:redstone_block",       quantity = 1 },
      { item = "minecraft:redstone",             quantity = 9 }
    },
    builderScript = miscbuilder.craftTunnel,
    catalystSlot = 3
  },
  {
    name = "Compact Walls",
    ingredients = {
      { item = "minecraft:iron_block", quantity = 1 },
      { item = "minecraft:redstone",   quantity = 2 }
    },
    builderScript = miscbuilder.craftWall,
    catalystSlot = 2
  }

}

return recipes
