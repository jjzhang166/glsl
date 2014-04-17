#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float hash(float x)
{
	return fract(sin(x) * 43758.5453);
}

float noise(vec3 v)
{
	/*
	vec3 p = floor(x);
	vec3 f = fract(x);
	f = f*f*(3.0-2.0*f);
	float n = p.x + p.y * 57.0 + p.z*113.0;
	
	float a = hash(n);
	return a;
	*/
	
	// I like this one better :)
	return hash(v.x*57.0 + hash(v.y*113.0) + hash(v.z*63.0));
}

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - 1.0;
	pos *= 5.0;

	
	
	float t = time;
	
	float cx = -0.5 + sin(t);
	float cy = -0.5 * cos(t);
	float x = abs(pos.x);
	float y = abs(pos.y);
	float m = x * x + y * y;
	x = x / m + cx + hash(x)*0.05;
	y = y / m + cy + hash(y)*0.5;
	
	vec4 col = vec4(0.0);
	
	col.r += clamp(1.0/sin(y/x), 0.0, 1.0);
	col.g += clamp(1.0/sin(x/y), 0.0, 1.0);
	col.b += clamp(1.0/tan(x/y), 0.0, 1.0);
	
	gl_FragColor = col;

}