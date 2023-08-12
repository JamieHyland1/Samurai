--todo: 
-- fix the parry mechanic
-- add directional attribute to players so they can change wether they face left or right
-- check how many frames have passed so you can determine wether a move has been parried or blocked
-- game feel tweeks such as small particles that fly out on parry or knockback
-- music and sfx
-- menus




shake = 0

--player1 object
player1 = {
	id= 'player1',
	x = 40,
	y = 90,
	dir = 1,
	knockback = 0,
	dash = 0,
	spr_index = 0,
	blocking = 0,
	wait = 0.3,
	anim_time = 0,
	parried = false,
	attacking = false,
	attacked  = false,
	atttacking_time = 0.07,
	attack = function(self, player)
		if(player.status ~= "blocked!") then
			if (abs_distance(self.x,player.x) <= 15) then
				player.dash = 0
				player.attacked = true
				player.knockback = player.x + (-15*player.dir)
			end
		end
	end,
	status = ""
}
--player2 object
player2 =
 {
	id = "player2",
	x = 57,
	y = 90,
	dir = -1,
	knockback = 0,
	dash = 0,
	spr_index = 0,
	blocking = 0,
	wait = 0.3,
	anim_time = 0,
	parried = false,
	attacking = false,
	attacked = false,
	atttacking_time = 0.08,
	attack = function(self, player)
		if(player.status ~= "blocked!") then
			if (abs_distance(self.x,player.x) <= 15) then
				player.dash = 0
				player.attacked = true
				player.knockback = player.x + (-15*player.dir)
			end
		end
	end,
	status = ""
}

--draw particles such as fire and snow
function draw_particles()
	for b in all(b_flame) do
  		b:show()
 	end
	for r in all(r_flame) do
  	 r:show()
  	end
	for s in all(snow) do
		s:draw()
	end
end

--update particles such as fire and snow
function update_particles()
	for b in all(b_flame) do
  		b:update()
 	end
 	for r in all(r_flame) do
  		r:update()
 	end
 	for s in all(snow) do
  		s:update()
	end
end

--update players position and state read inputs etc...
function update_players()
	--check direction of players
	if(player1.dash == 0 and player2.dash == 0 and player1.knockback == 0 and player2.knockback == 0)player1.dir = sgn(distance(player2.x,player1.x))
	if(player2.dash == 0 and player1.dash == 0 and player1.knockback == 0 and player2.knockback == 0)player2.dir = sgn(distance(player1.x,player2.x))
	--checking if a player is attacking or blocked
	if not player1.attacking or player1.status ~= "blocked!" then idle(player1) end
	if not player2.attacking or player2.status ~= "blocked!" then idle(player2) end
	if(player1.attacking) then attack(player1) end
	if(player2.attacking) then attack(player2) end
	if(player1.parried) then
		player1.attacking = false 
		player1.spr_index = 10
		player1.knockback += player1.x + (-12*player1.dir)
		player1.status = "parried! :("
		player1.parried = false
	end
	if(player2.parried) then
		player2.attacking = false 
		player2.spr_index = 10
		player2.knockback += player2.x + (-12*player2.dir)
		player2.status = "parried! :("
		player2.parried = false
	end


	--check for sword slash
	if(btnp(2,0) and player1.knockback == 0 and not player1.attacking) then 
		attack_status(player1)
	end

	if(btn(2,1) and player2.knockback == 0 and not player2.attacking) then 
		attack_status(player2)
	end
	--check for block
	if(btn(3,0) and player1.knockback == 0) then
		blocking_status(player1)
	end
	if(btn(3,1) and player2.knockback == 0) then
		blocking_status(player2)
	end
	--check for dash forward after knockback
	if(btnp(1,0) and player1.knockback == 0) then
		player1.dash = player1.x + (10*player1.dir)
	end

	if(btnp(0,0)) then
		player1.dash = 0
		player1.knockback = player1.x + (-10*player1.dir)
	end

	if(btnp(0,1) and player2.knockback == 0) then
		player2.dash = player2.x + (10*player2.dir)
	end
	if(btnp(1,1)) then
		player2.dash = 0
		player2.knockback = player2.x + (-10*player2.dir)
	end

	if(player1.dash > 0) then
		player1.x += abs((player1.x-player1.dash)*0.2)*player1.dir
		player1.spr_index = 0
	end
	
	if(player2.dash > 0) then
		player2.x += abs((player2.x - player2.dash) * 0.2)*player2.dir
		player2.spr_index = 0
	end
	
	--if(abs(player1.x - player2.x) < 8) then player1.dash = 0 end
	
	if(abs(player1.x-player1.dash) < 0.1) then
		player1.x = player1.dash
		player1.dash = 0
	end
	
	if(abs(player2.x-player2.dash) < 0.1) then
		player2.x = player2.dash
		player2.dash = 0
	end

	if(player1.knockback ~= 0) then 
		player1.x -= abs((player1.x - player1.knockback) * 0.2) * player1.dir
		player1.spr_index = 38
	end
	
	if(player2.knockback ~= 0) then 
		player2.x -= abs((player2.x - player2.knockback) * 0.2) * player2.dir
		player2.spr_index = 38
	end
	
	if(abs(player1.x - player1.knockback)<0.1) then
		player1.x = player1.knockback 
		player1.knockback = 0
		player1.attacked = false
		if(player1.parried) player1.parried = false
	end
	
	if(abs_distance(player2.x,player2.knockback) < 0.1) then
		player2.x = player2.knockback  
		player2.knockback = 0
		player2.attacked = false 
	end
end

--draw players
function draw_player(player, flipped)	 
	
	if player.spr_index == 14 then
		if(flipped) then spr(32,player.x-5, player.y-5, 2, 2, flipped) end
		if(flipped == false) then spr(32,player.x+5, player.y-5, 2, 2, flipped) end
		if(shake < 0.75) shake+=0.05
		if(player.id == 'player1') then player.attack(player1, player2) end
		if(player.id == 'player2') then player.attack(player2, player1) end
	end
	if(player1.knockback > 0) then 
		local dust = 34
		if(player1.dir == 1) then spr(dust,player1.x+10, player1.y, 2, 2,  true) end
		if(player1.dir == -1)then spr(dust,player1.x-10, player1.y, 2, 2, false) end
	end
	
	if(player1.dash > 0) then
		if(player1.dir == 1) then spr(34,player1.x-15, player1.y, 2, 2) end
		if(player1.dir == -1) then spr(34,player1.x+15, player1.y, 2, 2, true) end
	end
	
	if(player2.dash > 0) then
		if(player2.dir == -1)then spr(34,player2.x+15, player1.y, 2, 2, true) end
		if(player2.dir ==  1)then spr(34,player2.x-15, player1.y, 2, 2, false) end
	end
	
	if(player2.knockback > 0) then 
		local dust = 34
		if(player2.dir == -1)then spr(dust,player2.x-10, player2.y, 2, 2, false) end
		if(player2.dir ==  1)then spr(dust,player2.x+10, player2.y, 2, 2, true) end
	end
	spr(player.spr_index,player.x, player.y, 2, 2, flipped)	
end

--draw background
function draw_background()
	map(1,23,0,106)
 	circfill(24, 18, 14, 7)
 	circfill(28, 17, 10, 0) 
end

--init function
function _init()
	snow    = {}
	r_flame = {}
	b_flame = {} 
end

--update function
function _update60()
	offset = .01
	print(btnp(0), 50,50)
	print(btnp(1), 50,60)
	print(btnp(2), 50,50)
	print(btnp(3), 50,50)
	update_players()
	checklocation(player1)
	checklocation(player2)

	--generate snow and flames 
	generate_snow()
	generate_flames(r_flame,rnd(40),120,8)
	generate_flames(b_flame,60+rnd(70),120,12)
	update_particles()

	if(time() < 0) then  reload() end
end

--draw function
function _draw()
	--clear canvas
	cls()
	screen_shake()
	--draw the floor and the moon
 	
 	print(player2.x, 40,40)
 	print(player2.knockback,40,50)
 	
 	if(player1.knockback > 0 or player2.knockback > 0) then print("chance!!",45, 80, 7) end
	--player 1 code
	print(player1.status, player1.x,player1.y-5,8)
	if(player1.dir == 1)  then  draw_player(player1, false) end
	if(player1.dir == -1) then  draw_player(player1, true)  end
	

	--player 2 code
	pal(8,12)
	print(player2.status, player2.x,player2.y-5,12)
	if(player2.dir == -1) then draw_player(player2, true) end
	if(player2.dir == 1) then  draw_player(player2,false) end
	pal()
	
	
	--draw particles
	draw_particles()
	draw_background()
	player1.status = " "
 	player2.status = " "
end

--attack animation
function attack(player)
	if time() - player.anim_time > player.atttacking_time then
	player.spr_index += 2
		player.anim_time = time()
		if player.spr_index > 14 then
			player.attacking = false
			player.spr_index = 0
		end
	end
end

--idle function
function idle(player)
 if time() - player.anim_time > player.wait then
	player.spr_index += 2
		player.anim_time = time()
		if player.spr_index > 8 then
			player.spr_index = 0
			player.blocking = 7
		end
	end
end

--generate snow
function generate_snow()
  add(snow, {
 	x=rnd(130),
 	y=0,
 	r = rnd(2),
 	dx= rnd(0.5)-0.5,
 	dy=0.7,
 	life=100,
 	draw=function(self)
 	 circ(self.x,self.y,self.r ,7)
 	end,
 	update=function(self)
 		self.x+=self.dx
 		self.y+=self.dy

 		self.life-=1
   	if self.life<0 then
 			del(snow,self)
 		end
 	end
 })
end

--generate flames
function generate_flames(table, xpos, ypos, col)
  add(table, {
 	x= xpos,    --rnd(120),
 	y= ypos,    --120
 	r = rnd(6),
 	dx= rnd(4)-2,
 	dy=-1,
 	life=15,
 	show=function(self)
 	 circfill(self.x,self.y,self.r ,col)
 	end,
 	update=function(self)
 		self.x+=self.dx
 		self.y+=self.dy

 		self.life-=1
   	if self.life<0 then
 			del(table,self)
 		end
 	end
 })
end

function generate_flames(table, xpos, ypos, col)
  add(table, {
 	x= xpos,    --rnd(120),
 	y= ypos,    --120
 	r = rnd(6),
 	dx= rnd(4)-2,
 	dy=-0.5,
 	life=15,
 	show=function(self)
 	 circfill(self.x,self.y,self.r ,col)
 	end,
 	update=function(self)
 		self.x+=self.dx
 		self.y+=self.dy

 		self.life-=1
   	if self.life<0 then
 			del(table,self)
 		end
 	end
 })
end

--screen shake
function screen_shake()
	local shake_x = 16-rnd(24)
	local shake_y = 16-rnd(24)

	shake_x *= shake
	shake_y *= shake

	camera(shake_x,shake_y)

	shake  *= 0.95
	if shake < 0.05 then shake = 0 end
end

--lerp
function lerp(x,dx,incr)
	x -= (x-dx)*incr
	return x 
end

--absolute lerp
function abs_lerp(x,dx,incr)
	x -= abs((x-dx)*incr)
	return x
end

--debug
function debug(player)
	print(tostr(player.spr_index),10,10)	
	print(tostr(player.wait,10,30))
	print(tostr(player.atttacking_time),10,50)
	print(tostr(player.attacking,10,70))
	print(tostr(player.anim_time),10,90)  
	print(tostr(player.attacked),10, 100)	
end	

--draw smoke
function draw_smoke(player)
	timer -= 1
	if(timer == 0)index += 2
	if(timer == 0)timer = 5
	if(index == 38) then index = 34 end 
 if(player.id == "player1")then	spr(index,player.x,player.y,2,2,true)end
end

--return the distance of two variables
function distance(x,y)
	return x-y
end

--return the absolute distance between two values
function abs_distance(x,z)
	return abs(x-z)
end
--determin wether a player parrys and attack or simply blocks it
function blocking_status(p)
	p.dash = 0
	if(p.blocking > 0) then p.blocking -= 1 end
	p.attacking = false
	p.spr_index = 10
	p.status = "blocked!"
	if(p.id == "player1" and p.blocking > 0 and abs_distance(player1.x, player2.x) < 15 and player2.attacking) player2.parried = true
	if(p.id == "player2" and p.blocking > 0 and abs_distance(player1.x, player2.x) < 15 and player1.attacking) player1.parried = true  
end

function attack_status(p)
	p.dash = 0
	p.attacking = true
	sfx(2)
	p.spr_index = 8
	p.status = "attack!"
end

function checklocation(p)
	
	if(p.id == "player1") then
		if(p.x < 13) then
			p.y += 3
			player2.status = "you win!!"

		end
	end
	if(p.id == "player2") then
		if(p.x > 90) then
			p.y += 3
			player1.status = "you win!!"
		end
	end
end