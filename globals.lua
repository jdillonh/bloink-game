globals = {}




--globals
--dr_factor = delta radian factor; slows down the paddle rotate
--dt_new_ball is tempo, time b/w ball instantiations
--max_vel is the estimates max_vel of any ball in the scene (used for note picking)
globals = {
dr= 0.2, dr_factor = 20, gravity=400,
dt_new_ball=2, min_dt_new_ball = 0.07,max_dt_new_ball = 5, time_elapsed=0,
spacePressed = false, square_emitter_created = false,max_vel = 700, text = ""}


return globals
