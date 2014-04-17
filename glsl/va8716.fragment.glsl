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
	
	float mpos = length(mouse-position);
	mpos = (pow(mpos, 2.)*0.1);
	position += mpos;
	// Three dimensions of random(ish) 0-1 values
	vec2 rnd2 = vec2(mod(fract(sin(dot(position + time * 0.001, vec2(14.9898,78.233))) * 43758.5453), 1.0),
	                mod(fract(sin(dot(position + time * 0.001, vec2(24.9898,44.233))) * 27458.5453), 1.0));
	vec4 rnd4 = vec4(rnd2.x, rnd2.y,
	                mod(fract(sin(dot(position + time * 0.001, vec2(52.7533,64.756))) * 36435.7532), 1.0), 1.0);
	vec2 dither = vec2(sin(time * 57.575),
			   sin(time * 85.635));

	// Position nudge for waves in zoom rate
	vec2 nudge = vec2(12.0 + 10.0 * cos(time * 0.03775 + position.y),
	                  12.0 + 10.0 * cos(time * 0.02246 + position.x));

	// Zoom rate
	vec2 rate = 0.005 + 0.0012 * cos(nudge - 0.9 + time * mpos + position * 7.632);
	rate += 0.5 * rate.yx;

	float mradius = 0.2;
	if ((me.r < 0.05) && (me.g < 0.05) && (me.b < 0.05)) {
		// This pixel has gone dark -- randomize
		me = rnd4;
		// Greens tend to dominate; mute them
		//if (me.g > 0.6) me.g *= max(me.r, me.b);
	} else {
		// Zoom center
		vec2 cen = vec2(0.1 + 0.03 * sin(time * 0.016 + position.y * 1.0), 0.1 + 0.03 * sin(time * 0.03434231 + position.x * 2.0));
		vec2 mult = 1.0 - rate;

		// Jitter range
		vec2 jitter = vec2(1.1 / resolution.x,
		                   1.1 / resolution.y);

		// Source pixel offset
		vec2 offset = (rate * cen);// - (jitter * 0.5);

		// Find source pixel
		vec2 sourcepx = position * mult + offset + jitter * dither * 0.4;

		vec4 source = texture2D(backbuffer, sourcepx);
		
		// Copy and blend source with current pixel, apply a -slight- bit of random fade
		float blend = 0.0/127.0;
		me = (me * blend) + (source * (1.0-blend));
		me -= 0.1 * (rnd4 - 0.5) * (5.0 - ceil(mod(time * 0.1, 5.0))) * 0.08;
	}
	gl_FragColor = me;
}
