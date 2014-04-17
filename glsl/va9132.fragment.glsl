#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define BANDSIZE 0.02

//STATE 
//OF 
//THE 
//ART

float Scale(float f)
{
	return f/2.0+0.5;
}

bool Disk(vec2 p)
{
	return  (mod(length(p), 2.0*BANDSIZE)>BANDSIZE);
}

void main( void ) {

	float x = gl_FragCoord.x/resolution.y;
	float y = gl_FragCoord.y/resolution.y;
	vec2 mousescale = mouse;
	
	mousescale.x*=resolution.x/resolution.y;
	
	if (Disk(vec2(x,y)-mousescale))
	{
		gl_FragColor = vec4(1.0, 1.0, 0.0, 1.0 );
	}
	else 
	{
		vec2 p2 = vec2(Scale(cos(time*1.5)), Scale(sin(time*1.2)));
		
		if (Disk(vec2(x,y)-p2))
		{
			gl_FragColor = vec4(1.0, 1.0, 0.0, 1.0 );	
		}
		else
		{
			gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0 );
		}
	}
}