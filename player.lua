scale_ = 23.0;

player_vars=
{
    location_x = 1.0,
    location_y = 62.0,
    velocity_x=0.0,
    velocity_y=0.0,
    player_speed = 1200.0/scale_,
    player_width = 4.0,
    player_height = 4.0,
    player_status = 0, -- 0 = grounded, 1 = jumping, 2 = slash
    slash_time = 0,
    slash_speed = 0
}

function handle_slash()
    if(player_vars.slash_time < 0) then
        player_vars.slash_time = player_vars.slash_time + 1
    end

    if(player_vars.player_status != 2) then
        return
    end

    if(mouse_left_hold == false) then
        add_vel = vector_scale(vector_norm(vector((mouse_x-1)-player_vars.location_x,(mouse_y-1)-player_vars.location_y)),player_vars.slash_speed+135) 
        player_vars.velocity_x = add_vel.x;
        player_vars.velocity_y = add_vel.y
        player_vars.player_status = 0;
        player_vars.slash_time = -60;
    end
end

function update_player_movement()
    --left shift
    if(player_vars.player_status != 2) then
        if (btn(4,1)) then
            player_vars.player_status = 1;
        else
            player_vars.player_status = 0;
        end
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

    if(player_vars.slash_time <= -50 or 
       player_vars.player_status == 2) then
        acceleration.x = 0
        acceleration.y = 0
    end

    --friction based on PM_Friction from halflife/pm_chared.c at https://github.com/ValveSoftware/halflife
    if((player_vars.player_status == 0 and player_vars.slash_time > -50 ) or 
       player_vars.player_status == 2) then

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

function draw_player()
    if(player_vars.velocity_x>=0) then
        animate_once(player_vars.location_x,player_vars.location_y,{6},1,1,1,1)
    else
        animate_once(player_vars.location_x,player_vars.location_y,{5},1,1,1,1)
    end
end