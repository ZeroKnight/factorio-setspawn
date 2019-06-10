--[[
setspawn - control.lua

This file is part of 'Set Spawn', a Factorio Mod. See the LICENSE file that
should have been included with the distribution.

Author: Alex "ZeroKnight" George
--]]

require('commands')

function do_init()
  global.original_spawn = {}
  update_original_spawns()
  register_commands()
end

function do_load()
  register_commands()
end

function register_commands()
  commands.add_command("spawn", {"setspawn.help"}, dispatch_command)
end

function update_original_spawns(new_force)
  local os = global.original_spawn
  if new_force then
    os[new_force] = new_force.get_spawn_position(1)
  else
    for _, force in pairs(game.forces) do
      if not os[force.name] then
        os[force.name] = force.get_spawn_position(1)
      end
    end
  end
end

script.on_init(do_init)
script.on_load(do_load)
script.on_event(defines.events.on_force_created, update_original_spawns)