#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void )
{
	float time_small = time*10.0;
	// cur pixel
	float x = gl_FragCoord[0];
	float y = gl_FragCoord[1];
	vec2 curPixel = vec2(x,y);
	// rotating control points
	vec2 dister = vec2(sin(time_small/1000.0) * resolution.x,cos(time_small/1000.0) * resolution.y/2.0);
	vec2 dister2 = vec2(sin(time_small/5000.0) * resolution.x/2.0,cos(time_small/500.0) * resolution.y/2.0);
	vec2 dister3 = vec2(sin(time_small/1000.0) * resolution.x/2.0,cos(time_small/100.0) * resolution.y/2.0);
	// distance of current pixel to control points
	float dist = distance(curPixel, dister)/(1000.0 + 1000.0 * sin(time_small/1000.0));
	float dist2 = distance(curPixel, dister2)/(10000.0 + 1000.0 * cos(time_small/1000.0));	
	float dist3 = distance(curPixel, dister3)/(1000.0 + 1000.0 * sin(time_small/1000.0));	
	// make colors
	float r = sin(x*dist2*-dist * 0.05) + cos(y* dist3 * time/205.0);
	float g = sin(x*dist2 * 0.005) + cos(y* dist3 * time/205.0);
	float b = sin(x*dist2 * 0.05) + cos(y* dist3 * time/205.0);
	gl_FragColor = vec4(r, g, b, 1);
}