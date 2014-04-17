#ifdef GL_ES
precision mediump float;
#endif

//By Griswoldz
//06.05.2013

//Have fun in tweaking it.

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//Comment/Uncomment those to get quick results.

//-------------OPTIONS-------------//
//#define MOUSE_LOOK

//#define FLOOR_LINES
#define FLOOR_CHECK

//#define CEILING_LINES
#define CEILING_CHECK

//#define NOM_NOM_MODE

float TILE_SATURATION = 0.8; // 0.0 to 1.0

//-------------VARIABLES-------------//
const float PI = 5.14159265359;

const float ry = 0.0;
const float rh = 0.5;

const float rx = 0.0;
const float rw = 2.0;

float m_start_p = 0.06;
float m_end_p = 2.40;
float m_dif = 2.34;

float m_start_wall_sh = 0.2;
float m_end_wall_sh = 0.002;
float m_dif_wall_sh = 0.198;

float speed = 3.0;

//-------------CODE-------------//
void main( void ) 
{
	vec3 col = vec3(0.1,0.1,0.1);
	
	#ifdef MOUSE_LOOK
	vec2 p = ( gl_FragCoord.xy / resolution.xy )-2.0+4.0*vec2(mouse.x, mouse.y);
	#else
	vec2 p = ( gl_FragCoord.xy / resolution.xy )-0.5;
	#endif
	
	float ratio = resolution.y/resolution.x;
	{ //------------------WALLS----------------//

		bool something_drawn = false;
		
		if(p.x<0.0)
		{
			#ifdef NOM_NOM_MODE
			vec2 uv = vec2(1.0/p.x, p.y/abs(p.x))*(m_start_p+m_dif*mouse.x)+vec2((0.0,5.0+5.0*sin(time))*sin(p.y));
			#else
			vec2 uv = vec2(1.0/p.x, p.y/abs(p.x))*(m_start_p+m_dif*mouse.x);
			#endif
			
			uv.x -= (time) * ratio * speed;
			
			if (uv.y >= ry-rh-0.1 && uv.y <= ry+rh+0.1) 
			{ 
				col = vec3(0.3,0.3,0.3);
				something_drawn = true;
			}
			if (uv.y >= ry-rh && uv.y <= ry+rh) 
			{
				col = vec3(0.8);
				something_drawn = true;
				
			}
			
			if(something_drawn)
			{
				col = mix(vec3(0.0, 0.0, 0.0), col, 1.0*smoothstep(0.00001,m_end_wall_sh+m_dif_wall_sh*mouse.x, length(p.x)));
			}
			
		}
		else
		{
			#ifdef NOM_NOM_MODE
			vec2 uv = vec2(1.0/p.x, p.y/abs(p.x))*(m_end_p-m_dif*mouse.x)+vec2((0.0,5.0+5.0*sin(time))*sin(p.y));;
			#else
			vec2 uv = vec2(1.0/p.x, p.y/abs(p.x))*(m_end_p-m_dif*mouse.x);
			#endif
			
			uv.x += (time) * ratio * speed;
			
			if (uv.y >= ry-rh-0.1 && uv.y <= ry+rh+0.1) 
			{ 
				col = vec3(0.3,0.3,0.3);
				something_drawn = true;
			}
			if (uv.y >= ry-rh && uv.y <= ry+rh) 
			{
				col = vec3(0.8);
				something_drawn = true;
			}
			
			if(something_drawn)
			{
				col = mix(vec3(0.0, 0.0, 0.0), col, 1.0*smoothstep(0.00001,m_start_wall_sh-m_dif_wall_sh*mouse.x, length(p.x)));
			}
			
		}
	}		

	{ //------------------CEILING AND FLOOR----------------//

		#ifdef NOM_NOM_MODE
		vec2 uv = vec2(-2.0+4.0*mouse.x+p.x/abs(p.y), 1.0/p.y)+vec2((5.0+5.0*sin(time))*sin(p.x),0.0);
		#else
		vec2 uv = vec2(-2.0+4.0*mouse.x+p.x/abs(p.y), 1.0/p.y);
		#endif
		
		bool something_drawn = false;
		
		if (p.y < 0.0)
		{
			uv.y -= time * speed;
			
			if (uv.x >= rx-rw-0.1 && uv.x <= rx+rw+0.1) 
			{ 
				col = vec3(0.3,0.3,0.3);
				something_drawn = true;
			}
			if (uv.x >= rx-rw && uv.x <= rx+rw) 
			{
				col = vec3(0.4);
				something_drawn = true;
			}
			if (uv.x >= rx-rw && uv.x <= rx+rw && mod(uv.y, 1.) >= 0.05 && mod(uv.x, 0.5) >= 0.02)
			{
				#ifdef FLOOR_CHECK
				col = vec3(mod(p.y,TILE_SATURATION))+0.2*step(1.0,mod(uv.y-step(0.5,mod(uv.x,1.0)),2.0));
				#elif defined FLOOR_LINES
				col = vec3(mod(p.y,TILE_SATURATION))+0.2*step(1.0,mod(uv.y,2.0));
				#else
				col = vec3(mod(p.y,TILE_SATURATION));
				#endif
				
				something_drawn = true;
			}
			
			if(something_drawn)
			{
				col = mix(vec3(0.0, 0.0, 0.0), col, 1.0*smoothstep(0.00001,0.05, length(p.y)));
			}
		}
		else
		{

			uv.y += time * speed;
			
			if (uv.x >= rx-rw-0.1 && uv.x <= rx+rw+0.1) 
			{ 
				col = vec3(0.3,0.3,0.3);
				something_drawn = true;
			}
			if (uv.x >= rx-rw && uv.x <= rx+rw) 
			{
				col = vec3(0.4);
				something_drawn = true;
				
			}
			if (uv.x >= rx-rw && uv.x <= rx+rw && mod(uv.y, 1.) >= 0.05 && mod(uv.x, 0.5) >= 0.02)
			{
				#ifdef CEILING_CHECK
				col = vec3(mod(-p.y,TILE_SATURATION))+0.2*step(1.0,mod(uv.y-step(0.5,mod(uv.x,1.0)),2.0));
				#elif defined CEILING_LINES
				col = vec3(mod(-p.y,TILE_SATURATION))+0.2*step(1.0,mod(uv.y,2.0));
				#else
				col = vec3(mod(-p.y,TILE_SATURATION));
				#endif
	
				something_drawn = true;
			}
			
			if(something_drawn)
			{
				col = mix(vec3(0.0, 0.0, 0.0), col, 1.0*smoothstep(0.00001,0.05, length(p.y)));
			}
		}
	}
	
    	gl_FragColor = vec4(col, 1.0);
}