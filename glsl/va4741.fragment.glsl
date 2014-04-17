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
vec2 noiseXY(vec2 xy)
{
	vec2 v;
	v.x = noise(xy.x+0.1);
	v.y = noise(xy.y+0.2);
	
	v.xy /= sqrt(v.x*v.x+v.y*v.y);
	return v;
}

float interpolate(float a, float b, float x)
{
	float c = ((1.0-cos(3.14159265*x)))/2.0;

	return (1.0-c)*a + b*c;
}

float perlinXY(vec2 p)
{
	float intPX = floor(p.x);
	float intPY = floor(p.y);
	vec2 v1 = p-vec2(intPX,     intPY);
	vec2 v2 = p-vec2(intPX+1.0, intPY);
	vec2 v3 = p-vec2(intPX,     intPY+1.0);
	vec2 v4 = p-vec2(intPX+1.0, intPY+1.0);

	vec2 g1 = noiseXY(vec2(intPX,    intPY));
	vec2 g2 = noiseXY(vec2(intPX+1.0,intPY));
	vec2 g3 = noiseXY(vec2(intPX,    intPY+1.0));
	vec2 g4 = noiseXY(vec2(intPX+1.0,intPY+1.0));

	float s = dot(v1,g1);
	float t = dot(v2,g2);
	float u = dot(v3,g3);
	float v = dot(v4,g4);
	
	float a = interpolate(s,t,fract(p.x));
	float b = interpolate(u,v,fract(p.x));
	
	return interpolate(a,b,fract(p.y));
}

float getNoiseAtX(float x)
{
	
	return interpolate(noise(floor(x)),noise(floor(x)+1.0),fract(x));
}

void main( void ) {

	vec2 p = ( (gl_FragCoord.xy) / resolution.y );
	p.x -= resolution.x/resolution.y / 2.0;
	p.y -= 0.5;
	

	p*=100.0;
	float linex=0.5 / abs(p.y);
	float liney=0.5 / abs(p.x);
	float n = (perlinXY(vec2(p.x/10.0,p.y/10.0)+time));
	//if (abs(p.y) < 0.5)
	gl_FragColor += vec4(vec3(linex),1.0);
	gl_FragColor += vec4(vec3(liney),1.0);
	gl_FragColor += vec4(vec3(n),1.0);
	//if (abs(p.x) < 0.5)
		//gl_FragColor += vec4(vec3(1.0,1.0,1.0),1.0);
	
	
			
}