pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
-- include statements
#include animation.lua
#include intro.lua

-->8
-- init

delta_t = 1.0/60.0;
scale_ = 23.0;

player_vars=
{
    location_x = 20.0,
    location_y = 20.0,
    velocity_x=0.0,
    velocity_y=0.0,
    player_speed = 1200.0/scale_,
    player_width = 4.0,
    player_height = 4.0,
    player_status = 0, -- 0 = grounded, 1 = jumping
}

play_intro()

-->8
-- update
function _update60()

--left shift
if (btn(4,1)) then
    player_vars.player_status = 1;
else
    player_vars.player_status = 0;
end

acceleration = vector(0,0)
if (btn(0,1)) then 
		acceleration.x -= 1;
end
if (btn(1,1)) then 
		acceleration.x += 1;
end
if (btn(2,1)) then 
		acceleration.y -= 1;
end
if (btn(3,1)) then 
		acceleration.y += 1;
end

if (acceleration.x != 0) then 
		if (acceleration.y != 0) then 
            acceleration = vector_scale(acceleration,0.707106)
	    end
end

--friction based on PM_Friction from halflife/pm_chared.c at https://github.com/ValveSoftware/halflife
if(player_vars.player_status == 0) then

    speed = vector_length(vector(player_vars.velocity_x,player_vars.velocity_y)) 
    friction = 4;
    drop = 0;
    control = 0;
    if (speed < 100/scale_) then
        control = 100/scale_;
    else
        control = speed;
    end
    drop += (control*friction*delta_t);
    newspeed = speed - drop;
    if (newspeed < 0) then
        newspeed = 0;
    end
    if (newspeed != speed) then
        newspeed /= speed;
    end
    player_vars.velocity_x *= newspeed;
    player_vars.velocity_y *= newspeed;
    minus = vector_scale(vector(player_vars.velocity_x,player_vars.velocity_y),(1-newspeed));
    player_vars.velocity_x -= minus.x;
    player_vars.velocity_y -= minus.y;

end

--acceleration based on PM_Accelerate from halflife/pm_chared.c at https://github.com/ValveSoftware/halflife
current_speed = vector_inner(vector(player_vars.velocity_x,player_vars.velocity_y),acceleration)
addspeed = player_vars.player_speed - current_speed;

if(addspeed > 0) then
    accel = 10.0;
    accel_speed = accel * delta_t * player_vars.player_speed;
    if(accel_speed > addspeed) then
        accel_speed = addspeed;
    end
    acceleration = vector_scale(acceleration,accel_speed)
    player_vars.velocity_x += acceleration.x;
    player_vars.velocity_y += acceleration.y;
end

--move x / collision
movement_x = player_vars.velocity_x * (delta_t);
if(player_vars.location_x + movement_x < 0) then
    player_vars.velocity_x = 0;
    movement_x = 0;
end
if(player_vars.location_x + movement_x > 125) then
    player_vars.velocity_x = 0;
    movement_x = 0;
end
player_vars.location_x += movement_x;

--move y / collision
movement_y = player_vars.velocity_y * (delta_t);
if(player_vars.location_y + movement_y < 0) then
    player_vars.velocity_y = 0;
    movement_y = 0;
end
if(player_vars.location_y + movement_y > 125) then
    player_vars.velocity_y = 0;
    movement_y = 0;
end
player_vars.location_y += movement_y;

end
-->8
-- draw
function _draw()

cls(1)
animate(player_vars,player_vars.location_x,player_vars.location_y,{5,6},1,1,15)
print('E/S/D/F to move',2,2,7)
print(vector_length(vector(player_vars.velocity_x,player_vars.velocity_y)),2+6,2+6,12)
print('Hold left shift to hop',2+6,2+6+6,3)
handle_animations()

end

-->8
-- vector
-- based on PICO-8 Vector Calculation Library from https://www.lexaloffle.com/bbs/?tid=42625
function vector(sx,sy)
    return {
        x=(sx and sx or 0),
        y=(sy and sy or 0),
    }
end

function vector_inner(v1,v2)
    return ( (v1.x*v2.x) + (v1.y*v2.y) )
end

function vector_add(v1,v2)
    return vector(v1.x+v2.x,v1.y+v2.y)
end

function vector_minus(v1,v2)
    return vector(v1.x-v2.x,v1.y-v2.y)
end

function vector_multi(v1,v2)
    return vector(v1.x*v2.x,v1.y*v2.y)
end

function vector_scale(v1,scale)
    return vector(v1.x*scale,v1.y*scale)
end

function vector_length(v)
    return sqrt(v.x^2+v.y^2)
end

function vector_norm(v)
    local mag=vector_length(v)
    if mag>1 then
        return vector(v.x/mag,v.y/mag)
    end
    return v
end

function vector_dist(v1,v2)
    local x=abs(abs(v1.x)-abs(v2.x))
    local y=abs(abs(v1.y)-abs(v2.y))
    return x+y
end
__gfx__
ccccccc5555ccccc0000000000000000002020004446000088880000000000000000000000000000000000000000000000000000000000000000000000000000
cccccc555555cccc0000000000202000022022005ff2000088880000000000000000000000000000000000000000000000000000000000000000000000000000
ccccc55555155ccc222022202220222022000220ffff000088880000000000000000000000000000000000000000000000000000000000000000000000000000
ccccc55511111ccc000000000000000000000000feff000088880000000000000000000000000000000000000000000000000000000000000000000000000000
cccc55555ddd55cc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccc5d55555555cc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ccc55555ddddd5cc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cc55555dddddddcc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c555155d11111d1c0111100017771000111110007070000007070000007070000000000000000000000000000000000000000000000000000000000000000000
c555511d11111d1c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c555551d55555d1c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c555555ddd1d1d1c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c55555d5dddddd1c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
555555d5ddddd51c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
555555dd5555511c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
555555ddddddd11c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
