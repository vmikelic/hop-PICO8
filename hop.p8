pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
-- include statements
#include animation.lua
#include intro.lua
#include mouse.lua
#include player.lua
#include vector.lua
#include level.lua
#include enemy.lua

-->8
-- init

delta_t = 1.0/60.0;

enemies_killed = 0
lost = false

palt(0,false)
palt(10,true)
--play_intro()
init_mouse()

-->8
-- update
function _update60()

if(enemies_killed >= 50) then
    return
end

if(lost == true) then
    return
end


if(num_of_enemies < 6) then
    x_add = flr(rnd(119)+20)
    y_add = flr(rnd(119))
    bounce_add = rnd()
    add(enemy_list,enemy:new(x_add,y_add,bounce_add))
    num_of_enemies = num_of_enemies + 1
end

if(mouse_left_init) then
    player_vars.player_status = 2;
    player_vars.slash_speed = 0.3*vector_length(vector(player_vars.velocity_x,player_vars.velocity_y));
end
handle_slash()
update_player_movement()
player_enemy_collision()
update_enemy()
player_check_goal()
update_mouse()

end
-->8
-- draw
function _draw()

if(enemies_killed >= 50) then
    print('WIN',128/2-5,128/2-2,11)
    return
end

if(lost == true) then
    print('LOSE',128/2-5,128/2-2,8)
    return
end

cls(1)
draw_level()
draw_enemy()
draw_player()
print('E/S/D/F to move',2,2,7)
print('left click to slash',2+6,127-10,11)
print('Hold left shift to hop',2+6,127-4,3)
print(enemies_killed,2,8,8)
print(' /50',2+4,8,8)
print('enemies to win',2+4+17,8,11)
handle_animations()
draw_mouse()

end

__gfx__
ccccccc5555cccccaaaaaaaaaaaaaaaaaa2a2aaa4446aaaa4446aaaaa1aaaaaa77777777bbbbbbbba9a9a9a9444444448aaa2aa8aaaaaaaa00000000aaaaaaaa
cccccc555555ccccaaaaaaaaaa2a2aaaa22a22aa5f2faaaaf5f2aaaa171aaaaa7aaaa7a7babaaaab9aaaaaaa44555544a82aa28aa555555a00000000aaaaaaaa
ccccc55555155ccc222a222a222a222a22aaa22affffaaaaffffaaaa1771aaaa7aaaa7a7babaaaabaaaaaaa9454664542a8aa8a2a566665a00000000aaaaaaaa
ccccc55511111cccaaaaaaaaaaaaaaaaaaaaaaaafeffaaaaffefaaaa17771aaa7aaaa7a7babaaaab9aaaaaaa456446542aa882a2a555555a00000000aaaaaaaa
cccc55555ddd55ccaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa177771aaaaaaa7a7babaaaaaaaaaaaa945644654aa288aa2a566665a00000000aaaaaaaa
cccc5d55555555ccaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa17711aaaaaaaa7a7babaaaaa9aaaaaaa454664542a8aa8aaa555555a00000000aaaaaaaa
ccc55555ddddd5ccaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa1171aaaaaaaa7a7babaaaaaaaaaaaa944555544a8a2aa8aa335355a00000000aaaaaaaa
cc55555dddddddccaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa7a7babaaaaa9a9a9a9a444444448a2aa2a8333b33b300000000aaaaaaaa
c555155d11111d1ca1111aaa17771aaa11111aaa7a7aaaaaa7a7aaaaaa7a7aaaaaaaa7a7babaaaaaaa0000aa0000000000000000000000000000000000000000
c555511d11111d1caaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa7a7babaaaaaa077770a0000000000000000000000000000000000000000
c555551d55555d1caaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa7a7babaaaaaa070700a0000000000000000000000000000000000000000
c555555ddd1d1d1caaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa7a7babaaaaaa077570a0000000000000000000000000000000000000000
c55555d5dddddd1caaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa7a7babaaaaaa006060a0000000000000000000000000000000000000000
555555d5ddddd51caaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa7a7babaaaaaa700000a0000000000000000000000000000000000000000
555555dd5555511caaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa7a7babaaaaa007007000000000000000000000000000000000000000000
555555ddddddd11caaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa7a7babaaaaa000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000aaaaa7a7babaaaaa000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000aaaaa7a7babaaaaa000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000aaaaa7a7babaaaaa000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000aaaaa7a7babaaaaa000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000007aaaa7a7babaaaab000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000007aaaa7a7babaaaab000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000007aaaa7a7babaaaab000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000077777777bbbbbbbb000000000000000000000000000000000000000000000000
