// made by darkstalker (@wolfiestyle)
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float nrand(vec2 n)
{
	return fract(sin(dot(n.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

vec3 grad(float v)
{
	vec3 c = mix(vec3(1.,0.,0.),vec3(1.,1.,0.),v);
	c = mix(c,vec3(0,0.5,1),pow(v,10.0));
        c += mix(c,vec3(1.0),pow(v,64.));
	c = mix(vec3(0),c,v);
	return c;
}

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main( void )
{
	vec2 screen_pos = gl_FragCoord.xy;
	vec3 color = vec3(1.0,0.0,0.0);
		
	//Any live cell with fewer than two live neighbours dies, as if caused by under-population.
	//Any live cell with two or three live neighbours lives on to the next generation.
	//Any live cell with more than three live neighbours dies, as if by overcrowding.
	//Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

	
	vec4 c = texture2D(backbuffer, screen_pos/resolution);
	
	float a = 
		texture2D(backbuffer, (screen_pos + vec2(-1,-1))/resolution).x +
		texture2D(backbuffer, (screen_pos + vec2( 0,-1))/resolution).x +
		texture2D(backbuffer, (screen_pos + vec2( 1,-1))/resolution).x +
		texture2D(backbuffer, (screen_pos + vec2(-1, 0))/resolution).x +
		texture2D(backbuffer, (screen_pos + vec2( 1, 0))/resolution).x +
		texture2D(backbuffer, (screen_pos + vec2(-1, 1))/resolution).x +
		texture2D(backbuffer, (screen_pos + vec2( 0, 1))/resolution).x +
		texture2D(backbuffer, (screen_pos + vec2( 1, 1))/resolution).x;
	
	if( length(screen_pos - mouse*resolution) < 10.0 )
	{
		a = rand( screen_pos * time*0.1);
	}
	else
	{
		
		if(c.x > 0.5)
		{
			//alive
			if(a < 2.0 || a > 4.0)
			{
				a = 0.0;	
			}
			else
			{
				a = 1.0;
			}
		}
		else
		{
		//Dead
			if(a == 4.0)
			{
				a = 1.0;
			}
			else
			{
				a = 0.0;
			}
			
		}
	}
	color = c.xyz * 0.9;
	color.x = a;	
	
	color.xyz = color.xzx;
	
	gl_FragColor = vec4( color, 0 );
}