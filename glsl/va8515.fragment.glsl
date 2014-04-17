#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float m_start_p = 2.06;
float m_end_p = 2.40;
float m_dif = 0.34;

float speed = 10.0;

void main( void ) 
{
	vec3 col = vec3(0.1,0.2,0.65);
	
	vec2 p = ( gl_FragCoord.xy / resolution.xy )-0.5;
	float ratio = resolution.y/resolution.x;
	{ //------------------WALLS----------------//
		float ry = 0.0;
		float rh = 0.5;
		
		if(p.x<0.0)
		{
			
			vec2 uv = vec2(1.0/p.x, p.y/abs(p.x))*(m_start_p+m_dif*mouse.x);
			uv.x -= (time) * ratio * speed;
			
			if (uv.y >= ry-rh-0.1 && uv.y <= ry+rh+0.1) 
			{ 
				col = vec3(1.0,0.2,0.0);
			}
			if (uv.y >= ry-rh && uv.y <= ry+rh) 
			{
				col = vec3(1.0);
			}
		}
		else
		{
			vec2 uv = vec2(1.0/p.x, p.y/abs(p.x))*(m_end_p-m_dif*mouse.x);
			uv.x += (time) * ratio * speed;
			
			if (uv.y >= ry-rh-0.1 && uv.y <= ry+rh+0.1) 
			{ 
				col = vec3(1.0,0.2,0.0);
			}
			if (uv.y >= ry-rh && uv.y <= ry+rh) 
			{
				col = vec3(1.0);
			}
		}
	}
		
	{ //------------------CEILING AND FLOOR----------------//
		float rx = 0.0;
		float rw = 2.0;
		vec2 uv = vec2(-2.0+4.0*mouse.x+p.x/abs(p.y), 1.0/p.y);
		
		if (p.y < 0.0)
		{

			uv.y -= time * speed;
			
			if (uv.x >= rx-rw-0.1 && uv.x <= rx+rw+0.1) 
			{ 
				col = vec3(0.0,0.3,0.0);
			}
			if (uv.x >= rx-rw && uv.x <= rx+rw) 
			{
				col = vec3(0);
			}
			if (uv.x >= rx-rw && uv.x <= rx+rw && mod(uv.y, 1.) >= 0.05 && mod(uv.x, 0.5) >= 0.02)
			{
				col = vec3(0.8, 0.8, 0.8);
			}
		
		}
		else
		{

			uv.y += time * speed;
			
			if (uv.x >= rx-rw-0.1 && uv.x <= rx+rw+0.1) 
			{ 
				col = vec3(0.3,0.3,0.3);
			}
			if (uv.x >= rx-rw && uv.x <= rx+rw) 
			{
				col = vec3(0.4);
			}
			if (uv.x >= rx-rw && uv.x <= rx+rw && mod(uv.y, 1.) >= 0.05 && mod(uv.x, 0.5) >= 0.02)
			{
				col = vec3(0.0, 0.0, 0.8);
			}
		}
	}
	
	
    	gl_FragColor = vec4(col, 1.0);

}