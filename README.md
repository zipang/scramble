# scramble

A Scramble clone to learn [Lua](https://www.lua.org/pil/contents.html#P1) and the [LÖVE 2D engine](https://love2d.org/wiki/love)

## Installation

### Pre-require

Install the love2d engine from with your favourite package manager (for instance `yay love`)

Library organization (with git submodules) is taken from tutorial : http://www.osmstudios.com/page/love2d-platformer-tutorial-part-2-plumbing-a-game

To install the submodules (lua libraries from external git repo) you must type the following commands:

```sh
> git submodule init
Submodule 'lib/anim8' (git@github.com:kikito/anim8.git) registered for path 'lib/anim8'
Submodule 'lib/bump' (git@github.com:kikito/bump.lua.git) registered for path 'lib/bump'
Submodule 'lib/hump' (git@github.com:vrld/hump.git) registered for path 'lib/hump'
Submodule 'lib/lynput' (https://github.com/Lydzje/lynput.git) registered for path 'lib/lynput'

> git submodule update
Cloning into '/home/zipango/Workspace/projects/scramble/lib/anim8'...
Cloning into '/home/zipango/Workspace/projects/scramble/lib/bump'...
Cloning into '/home/zipango/Workspace/projects/scramble/lib/hump'...
Cloning into '/home/zipango/Workspace/projects/scramble/lib/lynput'...
Submodule path 'lib/anim8': checked out 'c1c12ec45fde28ffd2d6967675adcb3c3e501fa7'
Submodule path 'lib/bump': checked out '7cae5d1ef796068a185d8e2d0c632a030ac8c148'
Submodule path 'lib/hump': checked out '08937cc0ecf72d1a964a8de6cd552c5e136bf0d4'
Submodule path 'lib/lynput': checked out 'ee023e6745859ba6a7de3061af677e28a751331d'
```

Then to launch the game simply type `love main.lua`

