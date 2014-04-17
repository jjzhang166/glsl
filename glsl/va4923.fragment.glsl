#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 pixel = 1./resolution;
	vec4 me = texture2D(backbuffer, position);

	vec2 rnd = vec2(mod(fract(sin(dot(position + time * 0.001, vec2(14.9898,78.233))) * 43758.5453), 1.0),
	                mod(fract(sin(dot(position + time * 0.001, vec2(24.9898,44.233))) * 27458.5453), 1.0));
	vec2 nudge = vec2(12.0 + 10.0 * cos( 1.0* 0.03775),
	                  12.0 + 10.0 * cos(time * 0.02246));
	vec2 rate = -0.005 + 0.02 * (0.5 + 0.5 * cos(nudge * (position.yx - 0.5) + 0.5 + time * vec2(0.137, 0.262)));

	float mradius = 0.007;//0.07 * (-0.03 + length(zoomcenter - mouse));
	if (length(position-mouse) < mradius) {
		me.r = 0.5+0.5*sin(time * 1.234542);
		me.g = 0.5+0.5*sin(3.0 + time * 1.64242);
		me.b = 0.5+0.5*sin(4.0 + time * 1.444242);
	} else {
		rate *= 6.0 * abs(vec2(0.5, 0.5) - mouse);
		rate += 0.5 * rate.yx;
		vec2 mult = 1.0 - rate;
		vec2 jitter = vec2(1.1 / resolution.x,
		                   1.1 / resolution.y);
		vec2 offset = (rate * mouse) - (jitter * 0.5);
		vec4 source = texture2D(backbuffer, position * mult + offset + jitter * rnd);
		
		me = me * 0.05 + source * 0.95;
	}
	gl_FragColor = me;
}
