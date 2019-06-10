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
  for arg in string.gmatch(command.parameter, '(%S+)') do
    table.insert(args, arg)
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
      player.force.set_spawn_position(pos, 1)
      game.print{
        (gps and "setspawn.spawn-point-set-gps" or "setspawn.spawn-point-set"),
        player.force.name, pos.x, pos.y
      }
    else
      game.print{"invalid-parameter"}
    end
  elseif subcommand == "get" then
    pos = player.force.get_spawn_position(1)
    game.print{"setspawn.spawn-point-get", player.force.name, pos.x, pos.y}
  elseif subcommand == "show" then
    pos = player.force.get_spawn_position(1)
    game.print{"setspawn.spawn-point-show", player.force.name, pos.x, pos.y}
  elseif subcommand == "reset" then
    pos = global.original_spawn[player.force.name]
    player.force.set_spawn_position(pos, 1)
    game.print{"setspawn.spawn-point-reset", player.force.name, pos.x, pos.y}
  end
end