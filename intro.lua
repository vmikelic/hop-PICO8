intro_timer = 0
bounce = 0

function play_intro()
    if(intro_timer == 0) then
        animate_once(128/2-8,128/2-8,{0},2,2,175,2)
        animate_once(128/2-8+7,128/2-8+5,{2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,4,4,4,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4},1,1,5,1) --brow
        animate_once(128/2-8+8,128/2-8+9,{22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,20,22,20,20,22,21,21,21,22,23,20,20,20,23,23,23,23,23,23,23},1,1,5,1) --eyes
        animate_once(128/2-8+8,128/2-8+13,{18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,19,19,19,19,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20},1,1,5,1) --mouth
    end
    while(intro_timer <= 240) do
        cls(1)
        if(intro_timer > 175) then
            rectfill(128/2-8,128/2-8, 128/2-8+15,128/2-8+15,12)
            animate_once(128/2-8+((intro_timer-175)/3),128/2-8+sin(bounce),{0},2,2,1,1)
            animate_once(128/2-8+7+((intro_timer-175)/3),128/2-8+5+sin(bounce),{4},1,1,1,1) --brow
            animate_once(128/2-8+8+((intro_timer-175)/3),128/2-8+9+sin(bounce),{23},1,1,1,1) --eyes
            animate_once(128/2-8+8+((intro_timer-175)/3),128/2-8+13+sin(bounce),{19},1,1,1,1) --mouth
            rectfill(128/2-8+16,128/2-8, 128/2-8+15+16,128/2-8+15,1)
            if(bounce > 1) then
                bounce = 0
            else
                bounce = bounce + 0.07
            end
        end
        handle_animations()
        rectfill(128/2-8,128/2-8-16, 128/2-8+15+160,128/2-8+15-16,1)
        rectfill(128/2-8,128/2-8+15, 128/2-8+15+160,128/2-8+15+15,1)
        if(intro_timer > 175) then
            rectfill(128/2-8+16,128/2-10, 128/2-8+15+160,128/2-8+15,1)
        end
        print('APE',128/2-8+3,128/2-8+15,11)
        if(intro_timer > 25) then
            print('CONCERNED',128/2-8-9,128/2-8-6,8)
        end
        flip()
        intro_timer = intro_timer + 1
    end
    animation_data_once = {}
end