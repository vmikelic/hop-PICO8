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
game_timer = 0
spawn_rate = 180
num_of_obstacles = 2
levels_cleared = 0
enemy_requirement = 10

enemies_killed = 0
lost = false

palt(0,false)
palt(10,true)
play_intro()
init_mouse()
reset_level()

-->8
-- update
function _update60()

if(levels_cleared >= 6) then
    update_mouse()
    return
end

if(lost == true) then
    update_mouse()
    return
end

if(levels_cleared == 0) then
    player_vars.invuln_time = 100
end


if(game_timer%spawn_rate == 0) then
    enemy_added = false
    while(enemy_added == false) do
        enemy_slot = {x=flr(rnd(7)),y=flr(rnd(7))}
        add_enemy = true
        for i in all(occupied_slots) do
            if(enemy_slot.x == i.x and enemy_slot.y == i.y) then
                add_enemy = false
                break
            end
        end
        if(add_enemy == true) then
            enemy_added = true
        end
    end
    x_add = flr(rnd(119)+20)
    y_add = flr(rnd(119))
    bounce_add = rnd()
    add(enemy_list,enemy:new(11+enemy_slot.x*16,11+enemy_slot.y*16,bounce_add))
    num_of_enemies = num_of_enemies + 1
end

if(mouse_left_init and player_vars.slash_cooldown >= 0) then
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

if(levels_cleared >= 6) then
    cls(1)
    print('WIN',128/2-5,128/2-2,11)
    print('left click to restart',128/2-5-35,128/2-2+6,11)
    draw_mouse()
    if(mouse_left_init) then
        game_timer = 0
        spawn_rate = 160
        num_of_obstacles = 3
        levels_cleared = 1
        enemy_requirement = 10
        enemies_killed = 0
        mouse_left_init = false
        reset_level()
    end
    return
end

if(lost == true) then
    cls(1)
    print('LOSE',128/2-5,128/2-2,8)
    print('left click to restart',128/2-5-35,128/2-2+6,8)
    draw_mouse()
    if(mouse_left_init) then
        game_timer = 0
        spawn_rate = 160
        num_of_obstacles = 3
        levels_cleared = 1
        enemy_requirement = 10
        lost = false
        enemies_killed = 0
        mouse_left_init = false
        reset_level()
    end
    return
end

cls(1)
if(player_vars.slash_cooldown>=0) then
    if(game_timer%30 == 0) then
        animate_once(40,100+11,{80,81,82,83,84,85,80},1,1,5,1)
    end
end
rectfill(0 , 100+10-2, 50+1, 110+10+2, 13 )
rectfill(0 , 100+10, 50*(1-abs(player_vars.slash_cooldown/240)), 110+10, 12 )
draw_level()
draw_enemy()
draw_player()
if(levels_cleared == 0) then
    print('E/S/D/F to move',2,8,7)
    print('left click to slash',2+6,127-10-20,11)
    print('Hold left shift to hop',2+6,127-4-21,3)
    print('tutorial:no damage',2+6+45,127-4-21+10,3)
end
text_color = 8
if(enemies_killed >= enemy_requirement) then
    text_color = 11
end
print(enemies_killed,2,2,text_color)
print(' /',2+4,2,text_color)
print(enemy_requirement,2+4+6+4,2,text_color)
print(' enemies to proceed',2+4+17,2,11)
handle_animations()
draw_mouse()
game_timer = game_timer+1

end

__gfx__
ccccccc5555cccccaaaaaaaaaaaaaaaaaa2a2aaa4446aaaa4446aaaaa1aaaaaa77777777bbbbbbbbacadadac444444448aaa2aa8aaaaaaaa00000000aaaaaaaa
cccccc555555ccccaaaaaaaaaa2a2aaaa22a22aa5f2faaaaf5f2aaaa171aaaaa7aaaa7a7babaaaabdacaaaca44555544a82aa28aa555555a00000000aaaaaaaa
ccccc55555155ccc222a222a222a222a22aaa22affffaaaaffffaaaa1771aaaa7aaaa7a7babaaaabaaaaaaad454664542a8aa8a2a566665a00000000aaaaaaaa
ccccc55511111cccaaaaaaaaaaaaaaaaaaaaaaaafeffaaaaffefaaaa17771aaa7aaaa7a7babaaaabcaaaaaaa456446542aa882a2a555555a00000000aaaaaaaa
cccc55555ddd55ccaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa177771aaaaaaa7a7babaaaaaacaaaaac45644654aa288aa2a566665a00000000aaaaaaaa
cccc5d55555555ccaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa17711aaaaaaaa7a7babaaaaadaaaaada454664542a8aa8aaa555555a00000000aaaaaaaa
ccc55555ddddd5ccaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa1171aaaaaaaa7a7babaaaaaacaaacac44555544a8a2aa8aa335355a00000000aaaaaaaa
cc55555dddddddccaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa7a7babaaaaacadadaca444444448a2aa2a8333b33b300000000aaaaaaaa
c555155d11111d1ca1111aaa17771aaa11111aaa7a7aaaaaa7a7aaaaaa7a7aaaaaaaa7a7babaaaaaaa0000aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
c555511d11111d1caaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa7a7babaaaaaa077770aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
c555551d55555d1caaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa7a7babaaaaaa070700aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
c555555ddd1d1d1caaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa7a7babaaaaaa077570aaaaaaaaaaaaaaaaaaaaaaaaaaaa00aaaaaa00aaa
c55555d5dddddd1caaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa7a7babaaaaaa006060aaaaaaaaaaaaaaaaaaaaa0aaaaaa00aaaaa0000aa
555555d5ddddd51caaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa7a7babaaaaaa000000aaaaaaaaaaaa000aaaaa000aaaa0770aaa077770a
555555dd5555511caaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa7a7babaaaaa00700700aaaaaaaaa000000aa007700aa007700aa076760a
555555ddddddd11caaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa7a7babaaaaa000000000000000000000000000000000000000000000000
aaaaaaaaaaaaaaaa8aaaaaa8aaaaaaaaaaaaaaaaaa6aa6aa66aaaaa600000000aaaaa7a7babaaaaaaaaaaaaaaaa00aaaaa0000aaaa0000aaaaa8aaaa00000000
aaaaaaaaaaaaaaaa8aaaaaaaaaaaaaaaaaaaaaaaa6aaaaa6aaaaaaaa00000000aaaaa7a7babaaaaaaaaaaaaaaa0000aaa077770aa077770aa8aa8a8a00000000
aaaaaaaaa8aaaaaaaaaaaaaaaaa6aa6aaaa6aa6aaaaaaaaaaaaaaaaa00000000aaaaa7a7babaaaaaaaa00aaaa077770aa070700aa070700aaaa8aaaa00000000
aaaaaaaaa8aaaa8aaaaaaaaaaa66aa66aa6aaaa66a6aaaa6aaaaaaaa00000000aaaaa7a7babaaaaaa000000aa070700aa077570aa077570aa8aaaa8a00000000
aaaaaaaaaaaaaaaaaaa6a66aa66aaa66aa6aaa66aaaaaaaaaaaaaaaa000000007aaaa7a7babaaaaba077770aa077770aa006060aa006060aaaaaaaaa00000000
aaaaaaaaaaaaaaaaaa66aa6666aaaaa66aaaaaaa6aaaaaaaaaaaaaaa000000007aaaa7a7babaaaaba070700aa006060aa000000aa000000aaaaaaaaa00000000
aa8aa8aaaa66666aa66aaaa6aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa000000007aaaa7a7babaaaaba076760aa000000a0000000000000000aaaaaaaa00000000
aa868aaaa66aaa6aa6aaaaa6aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0000000077777777bbbbbbbb00000000000000000000000000700700aaaaaaaa00000000
aaaaaaaaaaaaaaaa9aaaaaa99aaaaaa9aaaaaaaaaaaaaaaaaaaaaaaaaaa8aaaaaaaa8aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa55aaa
aaaaaaaaaaaaaaaa9aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa8aaaaaa8aaaaa8aa8a8aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa555555a
aaaaaaaaaaaaaaa9aaaaaaa9aaaaaaaaaaaaaaaaaaaaaaaaaaa8aaaaaaa8aaaaa8aa8a8aaaa8aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa556655aa556655a
aaaaaaaaa9aaaaaaa9aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa8aaaa8aa8a8aaaa8aaaaa8aa8a8aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa555555aa555555a
aaaaaaaaaa9aa9aaaaaaaaaaaaaaaaaaaaaaaaaaaaa8aaaaaaa8aaaaaaa8aaaaa8aa8a8aaaa8aaaaaaaaaaaaaaaaaaaaaaaaaaaaa566665aa566665aa566665a
aaaaaaaaaa9aa9aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa8aaaa8aa8a8aa8aa8a8aaaa8aaaaa8aa8a8aaaaaaaaaaaaaaaaaaaaaaaaaa555555aa555555aa555555a
a99a99aaaaaaaaaaaaaaaaaaaaaaaaaaaaa8aaaaaaa8aaaaaaa8aaaaa8a88a8aa8aa8a8aa8a8aa8aaaaaaaaaa33a3aaaa335355aa335355aa335355aa335355a
aa9a9aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa8aaaaaaa8aaaa8aa8a8aa8a88a8aa8a88a8aaaa88aaaa33a3aaa333b33b3333b33b3333b33b3333b33b3333b33b3
aa7a77aaaa7a7aaaaa7a75a00a7a7a70aa7a7a70aa7a7a70aaaaaaaa88888888aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0000000000000000
aa7070aaa70750aaa70700a0a7a750a007a7aaaaaaaaaaa0aaad6d5a8a8aaaa8acaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0000000000000000
a0a7570aa076060a007a060a00aa0a0a0aaaaa06aaaaaaaaaa6dd65a8a8aaaa8acaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0000000000000000
a006060aa700a00aa70a000077aa0060aaaaaaaaaaaaaaa0aad6ad458a8aaaa8acaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0000000000000000
a700000a00700a00007a0aa00aaa0a000aaaaa000aaaaaaaaadaaaa58a8aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0000000000000000
00700a00a000000aaa00a00aa000a00a07aaaaa0aaaaaaaaaaaaaaa48a8aaaaaaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0000000000000000
a000000aaa0a00aaaaaa0aaaaa0a0aaaa0a0aa0aaaaaaaaaaaaaaaa78a8aaaaaaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0000000000000000
aa0a00aa00aaaaa000aaaaa000aaaaa0aaa0aaaa0aa0aaaaaaaaaaa48a8aaaaaaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0000000000000000
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa000000008a8aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0000000000000000
addaaaaaaadaadaaaaaaaaaaaaaaaaaaddaaaaaaaddaaaaa000000008a8aaaaaaaaaaaaaaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0000000000000000
adddaaaaaaddaadaaaadaadadaaaadaddaaaaadaadddaaaa000000008a8aaaaaaaaaaaaaaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0000000000000000
adaddaaaaaaddaaaaaaddaaddaaaddaadaaaaddaadaaaaad000000008a8aaaaaaaaaaaaaaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0000000000000000
adaddaaaaaaddaaaaaaddaaddaaaddaadaaaaddaadaaaaad000000008a8aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0000000000000000
adddaaaaaaddaadaaaadaadadaaaadaddaaaaadaadddaaaa000000008a8aaaaaaaaaaaaaaaaaaaaaaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa0000000000000000
addaaaaaaadaadaaaaaaaaaaaaaaaaaaddaaaaaaaddaaaaa000000008a8aaaaaaaaaaaaaaaaaaaaaaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa0000000000000000
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa000000008a8aaaaaaaaaaaaaaaaaaaaaaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa0000000000000000
000000000000000000000000000000000000000000000000000000008a8aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0000000000000000
000000000000000000000000000000000000000000000000000000008a8aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaacaaaaaaaaaaaaaa0000000000000000
000000000000000000000000000000000000000000000000000000008a8aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaacaaaaaaaaaaaaaa0000000000000000
000000000000000000000000000000000000000000000000000000008a8aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaacaaaaaaaaaaaaaa0000000000000000
000000000000000000000000000000000000000000000000000000008a8aaaa8aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0000000000000000
000000000000000000000000000000000000000000000000000000008a8aaaa8aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaacaaaaaa0000000000000000
000000000000000000000000000000000000000000000000000000008a8aaaa8aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaacaaaaaa0000000000000000
0000000000000000000000000000000000000000000000000000000088888888aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0000000000000000
