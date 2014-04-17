#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const vec4 color = vec4(0,1,0,1);

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy );// + mouse / 4.0;

	vec2 pr = abs(p-0.5);
	float f = (p.x*6.+pr.y*2.);

	gl_FragColor = mix(color, vec4(0.4,0.4,0.4,1.), step(0.025, abs(pr.y-0.4)));
	
	//float x = step(pr.y, 0.25) * step(fract(f*2.), 0.8) * step(fract(f * .5), 0.7);
	float x = smoothstep(0.25, 0.2, pr.y) * smoothstep(0.0,.4,fract(f*2.)) * smoothstep(0.0,.4,1.-fract(f*2.)) * step(fract(f * .5),0.75);
	gl_FragColor = mix(gl_FragColor, color, step(0.4, x));
	
	if (x > 0.7)
		discard;
}