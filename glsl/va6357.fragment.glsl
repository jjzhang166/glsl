#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float PI = 3.141;

// not quite what I expected from the backbuffer..


void main( void ) {

	vec2 p = vec2(gl_FragCoord.xy / resolution.xy);
	vec4 col = vec4(0.0, 0.0, 0.0, 1.0);
	float y4 = 0.1-(cos(p.x+mouse.x+time*0.25)*cos(mouse.y+p.x*PI*2.5*(1.0+sin(time*0.15)))*sin(p.x*PI*(mouse.x+cos(time*0.35)*0.15)*35.0)+2.0)*0.25;
	col.xyz = vec3(1.0 - clamp(mod(floor(resolution.y*(p.y - y4)), resolution.y), 0.0, 1.0));
	col.z += texture2D(backbuffer, vec2(p.x+1.0*(cos(time*1.25))/resolution.x, p.y+15.0/resolution.y)).z;
	if (p.y > 0.998) {
		col = vec4(0.0, 0.0, 0.0, 1.0);	
	}
	gl_FragColor = col;
}