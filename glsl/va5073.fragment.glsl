// Conway's game of life
//
// Move mouse right to speed up, left to slow down.

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

vec4 live = vec4(0.5,1.0,0.7,1.);
vec4 dead = vec4(0.,0.,0.,1.);
vec4 blue = vec4(0.,0.,1.,1.);

vec2 pixel = 4.0/resolution;

vec2 modPos(vec2 pos) {
	pos -= 0.5;
	return vec2(floor(pos.x / pixel.x + 0.5) * pixel.x,
		    floor(pos.y / pixel.y + 0.5) * pixel.y) + 0.5;
}

void main( void ) {
	vec2 position = modPos((gl_FragCoord.xy / resolution.xy ));
	float cycle = mod(time, 1.0);
	float speed = (1.0 - mouse.x) * 0.7;

	vec4 me = texture2D(backbuffer, position);
	vec4 corner = texture2D(backbuffer, vec2(0.0));
	if (cycle < corner.a) {
		cycle += 1.0;
	}

	if (length(position-modPos(mouse)) < 0.01) {
		float rnd1 = mod(fract(sin(dot(position + time * 0.001, vec2(14.9898,78.233))) * 43758.5453), 1.0);
		if (rnd1 > 0.5) {
			gl_FragColor = live;
		} else {
			gl_FragColor = blue;
		}
		gl_FragColor.a = mod(time, 1.0);
	} else if ((cycle - corner.a) < speed) {
		gl_FragColor = me;
	} else {
		float sum = 0.;
		sum += texture2D(backbuffer, position + pixel * vec2(-1., -1.)).g;
		sum += texture2D(backbuffer, position + pixel * vec2(-1., 0.)).g;
		sum += texture2D(backbuffer, position + pixel * vec2(-1., 1.)).g;
		sum += texture2D(backbuffer, position + pixel * vec2(1., -1.)).g;
		sum += texture2D(backbuffer, position + pixel * vec2(1., 0.)).g;
		sum += texture2D(backbuffer, position + pixel * vec2(1., 1.)).g;
		sum += texture2D(backbuffer, position + pixel * vec2(0., -1.)).g;
		sum += texture2D(backbuffer, position + pixel * vec2(0., 1.)).g;

		if (me.g <= 0.1) {
			if ((sum >= 2.9) && (sum <= 3.1)) {
				gl_FragColor = live;
			} else if (me.b > 0.004) {
				gl_FragColor = vec4(0., 0., max(me.b - 0.004, 0.25), 1.);
			} else {
				float rnd2 = mod(fract(sin(dot(position + time * 0.001, vec2(14.9898,78.233))) * 43758.5453), 1.0);
				if (rnd2 > 0.5) {
					gl_FragColor = live;
				} else {
					gl_FragColor = blue;
				}
			}
		} else {
			if ((sum >= 1.9) && (sum <= 3.1)) {
				gl_FragColor = live;
			} else {
				gl_FragColor = blue;
			}
		}
		gl_FragColor.a = mod(time, 1.0);
	}
}