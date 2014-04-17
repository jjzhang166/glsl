#ifdef GL_ES
precision highp float;
#endif

/* oldschool "fire" effect by joltz0r 2013-04-27*/

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D tex;
varying vec2 surfacePosition;

#define MIN_C 0.01
#define BLUR_SIZE 0.004

#define RND_MOD 1.0
#define RND_COEF 0.035

void main( void ) {

	vec2 pos = surfacePosition;
	vec2 p = ( gl_FragCoord.xy / resolution.xy );

	vec4 color = vec4(vec3(0.0), 1.0);
	
	float rnd = mod(p.x * tan(pos.x * time) * p.y * tan(pos.y * time * 81.0) * 8126386.123, RND_MOD);
	if ( p.y <= BLUR_SIZE) {
		if (rnd > (RND_MOD - RND_COEF)) {
			color = vec4(3.0, 1.75, 1.0, 1.0);

		}
	}
	
	color += texture2D(tex, vec2(p.x, p.y));
	if (rnd > (RND_MOD - 0.5)) {
		color += texture2D(tex, vec2(p.x + BLUR_SIZE, p.y));
	} else {
		color += texture2D(tex, vec2(p.x - BLUR_SIZE, p.y));
	}
	color += texture2D(tex, vec2(p.x, p.y - BLUR_SIZE));
	color += texture2D(tex, vec2(p.x, p.y - BLUR_SIZE * 2.0));
	color.rgb /= vec3(4.05, 4.2, 4.9);

	if ( color.r < MIN_C )
		color.r = 0.0;
	if ( color.g < MIN_C )
		color.g = 0.0;
	if ( color.b < MIN_C )
		color.b = 0.0;
	
	gl_FragColor = color;
}