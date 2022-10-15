pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
-- init
player_vars=
{
    location_x = 20.0,
    location_y = 20.0,
    velocity_x=0.0,
    velocity_y=0.0,
    player_speed = 4000.0,
    player_width = 10.0,
    player_height = 10.0,
    player_status = 0, -- 0 = grounded, 1 = jumping
    timer = 0
}

-->8
-- update
function _update60()
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

acceleration = vector_scale(acceleration,player_vars.player_speed)

player_vars.velocity_x += acceleration.x * (1.0/60.0);
player_vars.velocity_y += acceleration.y * (1.0/60.0);

movement_x = player_vars.velocity_x * (1.0/60.0);
if(player_vars.location_x + movement_x < 0) then
    movement_x = 0;
end
if(player_vars.location_x + movement_x > 117) then
    movement_x = 0;
end
player_vars.location_x += movement_x;

movement_y = player_vars.velocity_y * (1.0/60.0);
if(player_vars.location_y + movement_y < 0) then
    movement_y = 0;
end
if(player_vars.location_y + movement_y > 117) then
    movement_y = 0;
end
player_vars.location_y += movement_y;

if (btn(4,1) and player_vars.timer == 0) then
        player_vars.timer = player_vars.timer + 1;
		player_vars.player_status = 1;
else
        player_vars.player_status = 0;
end

--friction based on halflife/pm_chared.c from https://github.com/ValveSoftware/halflife
if (player_vars.timer <= 0) then 
		speed = vector_length(vector(player_vars.velocity_x,player_vars.velocity_y)) 
        friction = 4;
        drop = 0;
        control = 0;
        if (speed < 100) then
            control = 100;
        else
            control = speed;
        end
        drop += (control*friction*(1/60));
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
else
        player_vars.timer = player_vars.timer + 1;
        if (player_vars.timer > 5) then
            player_vars.timer = -180;
        end
end

if (player_vars.timer < 0) then
            player_vars.timer = player_vars.timer + 1;
end

end
-->8
-- draw
function _draw()

cls()
if (player_vars.player_status == 1) then 
		spr( 2, player_vars.location_x, player_vars.location_y)
else
        spr( 1, player_vars.location_x, player_vars.location_y)
end

print('E/S/D/F to move',2,2,7)
if (player_vars.timer < 0) then
            print(player_vars.timer,2+6,2+6,8)
else
            print('left shift to dash',2+6,2+6,12)
end

end

-->8
-- PICO-8 Vector Calculation Library
-- from https://www.lexaloffle.com/bbs/?tid=42625
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
00000000cccccccc8888888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000cccccccc8888888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700cccccccc8888888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000cccccccc8888888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000cccccccc8888888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700cccccccc8888888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000cccccccc8888888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000cccccccc8888888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
