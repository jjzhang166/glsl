#ifdef GL_ES
precision mediump float;
#endif

#define SHOOT_WITH_DELAYS 1

vec2 position;
vec2 player;
float dx, dy;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

bool eq_delta(float x, float y, float d){ return x>y-d && y>x-d;}
int modulo(int x,int y){return x-y*int(floor(float(x)/float(y)));}
float sq(float x){return x*x;}
float dist(vec2 x,vec2 y){return sqrt(sq(x.x-y.x)+sq(x.y-y.y));}
float dist2d(vec4 x,vec4 y){return sqrt(sq(x[0]-y[0])+sq(x[1]-y[1]));}

int idx_array(float arr_id, int arr_size)
{
	if ( (position.y > 1.0-dy*arr_id) || (position.y < 1.0-dy*(arr_id+1.0)) )
		return -1;
	int idx = int(floor(position.x/dx));
	return ( idx > arr_size ) ? -1 : idx; 
}
vec4 get_array(float arr_id, int i)
{
	return texture2D( backbuffer, vec2(2.0*(float(i)+1.0)*dx/2.0,1.0-dy*(2.0*arr_id)/2.0) );
}

#define N_STAT 0
#define I_STAT 1.0
int idx_stat() { return idx_array(I_STAT,N_STAT); }
vec4 get_stat(int i) { return get_array(I_STAT,i); }
int stat_state(vec4 t) {return (t[3] <= 0.5) ? 0 : 1; }
#define N_BULLETS 100
#define I_BULLETS 1.0
int idx_bullet() { return idx_array(I_BULLETS,N_BULLETS); }
vec4 get_bullet(int i) { return get_array(I_BULLETS,i); }
int bullet_state(vec4 t) {return (t[3] == 0.0) ? 0 : 1; }
#define N_EVIL     10
#define I_EVIL     2.0
#define EVIL_R     0.075
#define EYE_SIZE   (EVIL_R/5.0)
#define EYE_PUPIL_SIZE   (EYE_SIZE/3.0)
#define EVIL_SPEED 0.5
int idx_evil() { return idx_array(I_EVIL,N_EVIL); }
vec4 get_evil(int i) { return get_array(I_EVIL,i); }
int evil_state(vec4 t) {return (t[3] == 0.0) ? 0 : (t[2] > 0.0) ? 1 : 2; }
#define N_EBULLETS 100
#define I_EBULLETS 4.0
int idx_ebullet() { return idx_array(I_EBULLETS,N_EBULLETS); }
vec4 get_ebullet(int i) { return get_array(I_EBULLETS,i); }
int ebullet_state(vec4 t) {return (t[3] == 0.0) ? 0 : 1; }
#define I_MAX     5.0

vec4 move_bullets(int id)
{
	vec4 tmp = get_bullet(id);
	
	if (tmp[1] > 0.0)
	{
		tmp[3] += 0.001;
		tmp[1] += 0.005;
	}
	if (tmp[1] > 1.0)
		tmp = vec4(0.0,0.0,0.0,0.0);
	if (bullet_state(tmp) == 0)
	{
#if SHOOT_WITH_DELAYS
		if ( modulo(int(10.0*(time-float(int(time)))),3) == 1 )
#endif
		{	
			for(int i=0; i<N_BULLETS; i++)
			{
				if(i>=id) break; //no non-constant loops, lol
				if (bullet_state(get_bullet(i)) == 0)
					return vec4(0.0,0.0,0.0,0.0);	
			}
			return vec4(player.x,player.y,1.0,0.1);	
		}
	}
	else
	{
		for(int i=0; i<N_EVIL; i++)
		{
			vec4 evil = get_evil(i);
			if ( evil_state(evil) != 1) continue;
			if ( dist2d(evil,tmp) < EVIL_R*0.95 )
				return vec4(0.0,0.0,0.0,0.0);	
		}
	}
	return tmp;
}

vec4 move_ebullets(int id)
{
	vec4 tmp = get_ebullet(id);
	
	if (tmp[1] > 0.0)
	{
		tmp[3] += 0.001;
		tmp[1] -= 0.005;
	}
	if (tmp[1] < 0.0)
		tmp = vec4(0.0,0.0,0.0,0.0);
	if (ebullet_state(tmp) == 0)
	{
		for(int i=0; i<N_EBULLETS; i++)
		{
			if(i>=id) break; //no non-constant loops, lol
			if (ebullet_state(get_ebullet(i)) == 0)
				return vec4(0.0,0.0,0.0,0.0);	
		}
		int i = modulo(int(10.0*(time-float(int(time)))),N_EVIL);
		{
			vec4 evil = get_evil(i);
			if ( evil_state(evil) == 1)
				return vec4(evil[0],evil[1],1.0,1.0);	
		}
	}

	return tmp;
}

vec4 move_evil(int id)
{
	vec4 tmp = get_evil(id);
	float health = tmp[2];
	if (evil_state(tmp) == 0)
		health = 1.0;
	else
	{
		for(int i=0; i<N_BULLETS; i++)
		{
			vec4 bullet = get_bullet(i);
			if ( bullet_state(bullet) != 1) continue;
			if ( dist2d(bullet,tmp) < EVIL_R*1.0 )
				health -= 0.02;	
		}
	}
	if (health > 0.0)
	{
		float t = time*EVIL_SPEED+2.0*3.14*float(id)/float(N_EVIL);
		return vec4(0.5+sin(t)/4.0,0.8+cos(t)/8.0,health,1.0);
	}
	return vec4(0.0,0.0,0.0,1.0);
}

vec4 move_stat(int id)
{
	vec4 tmp = get_stat(id);
	if (tmp[3] == 0.0)
	{
		tmp[2] += 0.005;
		if (tmp[2] > 1.0)
			return vec4(0.0,0.0,0.0,0.1);
	}
	if (eq_delta(tmp[3],0.1,0.01))
	{
		tmp[2] += 0.005;
		if (tmp[2] > 1.0)
			return vec4(0.0,0.0,0.0,0.8);
	}
	return tmp;
}

vec4 borodach(vec4 obj, float d)
{
	float s = cos(3.14*d/EVIL_R/3.0-0.05);
	s = s*s;
	if (dist(vec2(obj[0]-2.0*EYE_SIZE,obj[1]+EYE_SIZE),position) < EYE_PUPIL_SIZE)
		return vec4(0.0,0.0,0.0,1.0);
	if (dist(vec2(obj[0]-2.0*EYE_SIZE,obj[1]+EYE_SIZE),position) < EYE_SIZE)
		return vec4(1.0,1.0,1.0,1.0);
	if (dist(vec2(obj[0]+2.0*EYE_SIZE,obj[1]+EYE_SIZE),position) < EYE_PUPIL_SIZE)
		return vec4(0.0,0.0,0.0,1.0);
	if (dist(vec2(obj[0]+2.0*EYE_SIZE,obj[1]+EYE_SIZE),position) < EYE_SIZE)
		return vec4(1.0,1.0,1.0,1.0);
	if (dist(vec2(obj[0]+2.0*EYE_SIZE,obj[1]+EYE_SIZE),position) < EYE_SIZE)
		return vec4(1.0,1.0,1.0,1.0);
	if (dist(vec2((obj[0]-position.x)/3.0,obj[1]-2.0*EYE_SIZE),vec2(0,position.y)) < EYE_SIZE)
		if (dist(vec2((obj[0]-position.x)/3.0,obj[1]-2.0*EYE_SIZE),vec2(0,position.y)) > EYE_SIZE/1.5)
			return vec4(0.0,0.0,0.0,1.0);
	return vec4((0.1+obj[2]*0.9)*s,0.1*s,0.1*s,1.0);
}

vec4 intro_color()
{
	int id;
	id = idx_bullet(); if ( id != -1) return vec4(0.0,0.0,0.0,0.0);
	id = idx_ebullet(); if ( id != -1 ) return vec4(0.0,0.0,0.0,0.0);
	id = idx_evil(); if ( id != -1 ) return vec4(0.0,0.0,0.0,0.0);
	vec4 tmp = get_stat(0);
	if (tmp[3] == 0.0)
		return tmp;
	if (eq_delta(tmp[3],0.1,0.01))
		return vec4(0.0,0.0,sin(1.0-tmp[2]*position.y),1.0);
	return vec4(0.0,1.0,0.0,1.0);
}

vec4 game_color()
{
	int id;
	float r = 0.25*(3.0+sin(time));
	float g = 0.25*(3.0+sin(time+2.0*3.14/3.0));
	float b = 0.25*(3.0+sin(time+4.0*3.14/3.0));
	vec4 n=vec4(r,g,b,1.0);

	id = idx_bullet(); if ( id != -1) return move_bullets(id);
	id = idx_ebullet(); if ( id != -1 ) return move_ebullets(id);
	id = idx_evil(); if ( id != -1 ) return move_evil(id);
	
 	if ( ((player.x-position.x)>0.0) && ((player.x-position.x)<0.01) && (abs(2.0*player.x+player.y-position.y-2.0*position.x)<0.02) )
		return vec4(0.918,0.918,0.042,1.0);
 	if ( ((player.x-position.x)<0.0) && ((player.x-position.x)>-0.01) && (abs(2.0*player.x-player.y+position.y-2.0*position.x)<0.02) )
		return vec4(0.195,0.554,0.164,1.0);
	
	for(int i=0; i<N_BULLETS-1; i++)
	{
		vec4 obj = get_bullet(i);
		if ( bullet_state(obj) == 1 )
	 		if ( (abs(obj[0]-position.x)<0.001) && (abs(obj[1]-position.y)<0.02) )
	 		    return n;
	}
	
	for(int i=0; i<N_EBULLETS-1; i++)
	{
		vec4 obj = get_ebullet(i);
		if ( ebullet_state(obj) == 1 )
	 		if ( (abs(obj[0]-position.x)<0.001) && (abs(obj[1]-position.y)<0.02) )
	 		    return vec4(0.0,0.0,0.0,0.0);
	}
	
	for(int i=0; i<N_EVIL; i++)
	{
		vec4 obj = get_evil(i);
		if ( evil_state(obj) == 1 )
		{
			float d = dist(vec2(obj[0],obj[1]),position);
 			if ( d < EVIL_R )
				borodach(obj, d);
		}
	}
	
	return vec4(0.0,0.0,sin(1.0-position.y),1.0);
}

void main(void)
{
	dx = 3.0/resolution.x;
	dy = 3.0/resolution.y;
	
	player = mouse.xy;
	if ( player.y >= 0.9 ) player.y = 0.9;
	if ( player.y < 0.01 ) player.y = 0.01;

	position = gl_FragCoord.xy/resolution.xy;

	int id;
	id = idx_stat();
	if ( id != -1) { gl_FragColor = move_stat(id); return; }
	if ( stat_state(get_stat(id)) == 0 ) { gl_FragColor = intro_color(); }
	if ( stat_state(get_stat(id)) == 1 ) { gl_FragColor = game_color(); }
}