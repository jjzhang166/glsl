#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// bonnie 
void main(void) {

	vec2 p = -1.0+2.0*gl_FragCoord.xy/resolution.xy;
	float dist = length(p);
	
	float x = sin(atan(p.y,p.x)*15.0 + sin(time) * dist * 6.0 );
	
	vec3 brightColor = vec3(sin(time * dist *3. ), 0.0, 1.0);
		
	gl_FragColor = vec4(brightColor * x, 1.0);
	
}