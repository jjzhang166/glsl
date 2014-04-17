#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const vec4 color = vec4(0.2,0.5,0,1);

void main( void ) {

	vec2 p  = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	vec2 pr = abs(p-0.5);
	float f = (p.x*6.+pr.y*2.-(time));
	
	float x = 
		step(pr.y, 0.35) * 
		step(fract(f*1.), 0.8) * 
		step(fract(f * .5), 0.7);

	gl_FragColor = mix(
		gl_FragColor, 
		color, 
		step(0.0, x)
		);
	
	if (x > 0.7)
		discard;
}