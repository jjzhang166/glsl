#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 p = position;
	//vec2 m = vec2(time*0.3, sin(time*6.0)*0.1);
	vec2 m = (vec2(sin(time*1.0)*0.5, cos(time*1.0)*0.5)*0.5+0.5) + vec2(sin(time*3.0)*0.1, cos(time*4.0)*0.1);
	p.x *= resolution.x / resolution.y;
	m.x *= resolution.x / resolution.y;
	float color = texture2D(backbuffer, position).x;
	if (color > 0.0) color = 1.0 - color;
	float d = length(mod(p - m, 0.1)-0.05);
	if(d < 0.02) {
		color=0.95;
	}

	gl_FragColor = vec4( color );

}