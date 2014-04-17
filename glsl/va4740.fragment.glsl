//cowabunga fuckfarts
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float noise (float x)
{
	return fract(cos(fract(x)*floor(x)*30.1692+0.63+floor(x)*60.293)*769.785629+32.6)*2.0-1.0;
}
float interpolate(float a, float b, float x)
{
	float c = ((1.0-cos(3.14159265*x)))/2.0;

	return (1.0-c)*a + b*c;
}
float getNoiseAtX(float x)
{
	
	return interpolate(noise(floor(x)),noise(floor(x)+1.0),fract(x));
}

float testFunction(float x)
{
	if (abs(x) < 50.0)
		return interpolate(50.0,0.0,x/50.0)/2.0;
	else
		return 0.0;
}
void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.y );
	p.x -= resolution.x/resolution.y / 2.0;
	p.y -= 0.5;

	p*=100.0;
	float fn = testFunction(p.x)+((getNoiseAtX(p.x/3.0+time*5.0)+1.0)/2.0)*1.5;//getNoiseAtX(p.x/5.0+time*5.0)*5.0);
	if (p.y < fn)
		gl_FragColor += vec4( vec3(fn/25.0,fn/5.0,fn/2.0), 1.0);	

//        gl_FragColor += vec4( vec3(fn*1.5,fn*2.0,fn*1.0), 1.0 );
			
}