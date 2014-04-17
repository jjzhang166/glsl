#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define USE_MOUSE 0

void main(void) {
	vec2 p     = gl_FragCoord.xy;
	vec3 color = vec3(0.0);
	vec2 sun   = vec2(resolution.x/2.0, resolution.y/2.0);
	
	#if USE_MOUSE
	sun.x *= mouse.x*2.0;
	sun.y *= mouse.y*2.0;
	#endif
	
	float d    = distance(p,sun);
	if (sin(atan((p.y-sun.y)/(p.x-sun.x))*16.0+time*2.0) > 0.0)
		color = mix(color, vec3(1.0,1.0,1.0),1.0);
	if (d < 200.0) color = vec3(1.0,0.0,0.0);
	gl_FragColor = vec4(color, 1.0);
}