#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float PI = 3.141;

// upsampling / downsampling

void main( void ) {

	vec2 p = vec2(gl_FragCoord.xy / resolution.xy);
	vec4 col = vec4(0.0, 0.0, 0.0, 1.0);
	float phase = time*0.1;
	float y4 = 0.01+0.49*mouse.y*(sin((phase+p.x)*PI*2.0*(10.0*mouse.x))+0.5*cos((phase+p.x)*PI*80.0*(10.0*mouse.x))+2.0);
	col.xyz = vec3(1.0 - clamp(mod(floor(resolution.y*(p.y - y4)*0.1), resolution.y), 0.0, 1.0));
	gl_FragColor = col;
}