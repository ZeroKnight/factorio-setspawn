--[[
setspawn - commands.lua

Command function definitions

This file is part of 'Set Spawn', a Factorio Mod. See the LICENSE file that
should have been included with the distribution.

Author: Alex "ZeroKnight" George
--]]

function dispatch_command(command)
  -- Splits command.parameter into an array and dispatches to the appropriate
  -- command handler
  local args = {}
  if command.parameter then
    for arg in string.gmatch(command.parameter, '(%S+)') do
      table.insert(args, arg)
    end
  end
  _G['command_' .. command.name](command, args)
end

function command_spawn(command, args)
  local player = game.players[command.player_index]
  local pos = player.position
  local gps = false

  local subcommand = table.remove(args, 1)
  if subcommand == "set" then
    if #args == 1 then
      pos.x, pos.y = args[1]:match('(%-?%d+%.?%d*),(%-?%d+%.?%d*)')
      if args[1]:match('gps') then
        gps = true
      end
    elseif #args == 2 then
      pos.x = tonumber(args[1])
      pos.y = tonumber(args[2])
    end
    -- Defaults to current position if no arguments given
    if pos.x and pos.y then
      player.force.set_spawn_position(pos, player.surface)
      update_map_tag(player, pos)
      player.force.print{
        (gps and "setspawn.spawn-point-set-gps" or "setspawn.spawn-point-set"),
        player.force.name, pos.x, pos.y
      }
    else
      player.print{"invalid-parameter"}
    end

  elseif subcommand == "map" then
    -- Toggles map tag for the current spawn point
    if not global.map_tag[player.force.name] then
      set_map_tag(player, player.force.get_spawn_position(player.surface))
      player.force.print{
        "setspawn.spawn-point-map-enabled", player.force.name
      }
    else
      global.map_tag[player.force.name].destroy()
      global.map_tag[player.force.name] = nil
      player.force.print{
        "setspawn.spawn-point-map-disabled", player.force.name
      }
    end

  elseif subcommand == "get" or subcommand == "show" then
    pos = player.force.get_spawn_position(player.surface)
    player.print{
      "setspawn.spawn-point-"..subcommand,
      player.force.name, pos.x, pos.y
    }

  elseif subcommand == "reset" then
    pos = global.original_spawn[player.force.name]
    player.force.set_spawn_position(pos, player.surface)
    update_map_tag(player, pos)
    player.force.print{
      "setspawn.spawn-point-reset", player.force.name, pos.x, pos.y
    }

  else
    player.print('Invalid subcommand')
    player.print({'setspawn.help'})
  end
end

function set_map_tag(player, pos)
  global.map_tag[player.force.name] = player.force.add_chart_tag(
    player.surface, {
    position = pos,
    text = "Spawn Point",
    last_user = player
  })
end

function update_map_tag(player, pos)
  local tag = global.map_tag[player.force.name]
  if tag then
    tag.destroy()
    set_map_tag(player, pos)
  end
end