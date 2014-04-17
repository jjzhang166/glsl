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
	float zoomspd=0.01;
	zoomspd=abs(cos(time))*0.02;
	position+=zoomspd/2.;
	position*=1.-zoomspd; // shabtronic - nice psuedo fractal zooooooooom!
	vec2 aspect = vec2(1.0, resolution.y / resolution.x);

	vec2 rnd = vec2(mod(fract(sin(dot(position + time * 0.001, vec2(14.9898,78.233))) * 43758.5453), 1.0),
	                mod(fract(sin(dot(position + time * 0.001, vec2(24.9898,44.233))) * 27458.5453), 1.0));
	vec2 nudge = vec2(12.0 + 10.0 * cos(time * 0.03775),
	                  12.0 + 10.0 * cos(time * 0.02246));
	vec2 rate = 0.0002 + 0.0012 * cos(0.0 * nudge + 0.5 + 0.0 * time * vec2(0.04137, 0.0262) + position * 7.0);

	float mradius = 0.012;
	if ((me.r == 0.0) && (me.g == 0.0) && (me.g == 0.0)) {
		me.r = mod(fract(sin(dot(position + time * 0.001, vec2(14.5373,78.2337))) * 43758.5453), 1.0);
		me.g = mod(fract(sin(dot(position + time * 0.001, vec2(64.9898,34.5373))) * 83467.5453), 1.0);
		me.b = mod(fract(sin(dot(position + time * 0.001, vec2(73.3265,32.6234))) * 52853.8632), 1.0);
		me.a = 1.0;
/*	
	if (length((position-mouse) * aspect) < mradius) {
		me.r = 0.5+0.5*sin(time * 1.234542);
		me.g = 0.5+0.5*sin(3.0 + time * 1.64242);
		me.b = 0.5+0.5*sin(4.0 + time * 1.444242);
*/
	} else {
		vec2 cen = vec2(0.5 + 0.3 * sin(time * 0.124623456 + position.y * 10.0), 0.5 + 0.3 * sin(time * 0.3434231 + position.x * 10.0));
		//vec2 cen = vec2(0.5, 0.5);
		rate += 0.5 * rate.yx;
		vec2 mult = 1.0 - rate;
		vec2 jitter = vec2(1.1 / resolution.x,
		                   1.1 / resolution.y);
		vec2 offset = (rate * cen) - (jitter * 0.5);
		vec4 source = texture2D(backbuffer, position * mult + offset + jitter * rnd);
		
		me = source - rnd.x / 500.0;
	}
	gl_FragColor = me;
}
