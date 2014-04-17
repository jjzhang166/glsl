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

float Disk(vec2 p)
{
	return smoothstep(.25,-.25, sin(length(p)*200.0));
}

void main( void ) {

	float x = gl_FragCoord.x/resolution.y;
	float y = gl_FragCoord.y/resolution.y;
	vec2 mousescale = mouse;
	
	mousescale.x*=resolution.x/resolution.y;
	
	
		
	
	vec2 p2 = vec2(Scale(cos(time*0.8)), Scale(sin(time*0.8)));
	float c = Disk(vec2(x,y)-p2);
	c += Disk(vec2(x,y)-mousescale);
	gl_FragColor = vec4(c, c, 0.0, 1.0 );	
	
}