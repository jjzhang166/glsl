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
	float x = sin(atan(p.y,p.x)*5.0 +time*2.0 + sin(time)*dist*0.5)/(dist*0.1+time*0.045);
	vec3 c = vec3(0.5*(1.0+cos(time)), 0.2*sin(2.0 + 10.0*(2.0+cos(time))*dist), 0.5*(1.0+cos(time*2.0)));
	gl_FragColor = vec4(x*c*cos(x+time), 1.0);
	
}