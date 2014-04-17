// fuck that shit.

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	const float s = 0.5;
	float x;
	x = cos(time*8.2*s)*0.1;
	x += sin(time*5.4*s)*0.1;
	x += sin(time*3.1*s)*0.3;
	x += sin(time*2.7*s)*0.4;
	x += sin(time*3.8*s)*0.1;
		
	vec2 position = gl_FragCoord.xy / resolution.xy - vec2(x*0.5+0.5, 0.5);

	float h1 = sin(time*1.0)*114.0/2.0+(sin(time)*30.0+180.0);
	float h2 = sin(time*2.0)*114.0/2.0+134.0;
	float h3 = sin(time*3.0)*114.0/2.0+154.0;
	
	float r = 1.0 - smoothstep(0., sin(time*0.5)*0.3+0.4, length(position*position.y*(sin(time*1.1)*3.0+h1*0.3)));
	float g = 1.0 - smoothstep(0., sin(time*0.7)*0.2+0.5, length(position*position.y*(sin(time*1.2)*3.0+h2*0.3)));
	float b = 1.0 - smoothstep(0., sin(time*0.9)*0.4+0.6, length(position*position.y*(sin(time*1.3)*3.0+h3*0.3)));
	
	r *= mod(gl_FragCoord.y, 2.0);
	
	gl_FragColor = vec4( r, g, b*b, 1.0);
}