# Set Spawn

Simple and minimal commands to manage player/force spawn point. Useful when
the starting spawn point is nowhere near your factory.

## Usage

The primary command is `spawn`, which accepts subcommands as its first
argument.

### set

`set [x,y | x y]` -- *Note: The brackets here represent optional parameters*

`set [gps=x,y]`

Sets the spawn point of the invoking user's force. If given no arguments,
uses the current position. Also accepts rich-text `[gps]` tags introduced in
v0.17.0, which can be conveniently inserted by shift-clicking somewhere on
the world.

### get

`get`

Prints the current spawn point of the invoking user's force to the console.

### show

`show`

Like `get`, but uses a `[gps]` tag, which shows the spawn point as a waypoint
on the map.

### map

`map`

Toggles a map tag showing the location of the spawn point, the same kind that
can be added by right-clicking on the map screen.

### reset

`reset`

The mod makes a note of the force's original spawn point. This command resets
the spawn point to this location.

## Other Information

This mod is in its infancy and could certainly be improved. Suggestions and
pull requests are absolutely welcome!
