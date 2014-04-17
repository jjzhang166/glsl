#ifdef GL_ES
precision mediump float;
#endif

// attempting to hypnotize the poor viewer, also backbuffer test for a friend =D - @dist
// edits by weyland

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D bb;

float SCREENZOOM = 6.0;
float BUFFERZOOM = 1.0;
float BUFFERFADE = 0.75;
float WIDTH = 0.2;
float BLADES = float(int(mod(time,5.0)));
float RPM = 5.0;

vec3 blob(vec2 p, float speed, float x, float y, vec3 color, float size) {
	float stime = time * speed;
	vec2 pos = vec2(cos(stime*x),sin(stime*y));
	return color * size/(distance(p, pos));
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 p1 = (gl_FragCoord.xy / resolution.xy - vec2(0.5,0.5));
	vec2 p2 = (gl_FragCoord.xy / resolution.xy - vec2(0.5,0.5)) * vec2(1.0, resolution.y/resolution.x) * SCREENZOOM * 0.7;
	vec3 color = vec3(0.0);
	
	color += blob(p2, 0.013, 2., 3., vec3(0.1,0.3,0.7), 0.2+cos(time/12.));
	color += blob(p2, 0.013, 4., 5., vec3(0.9,0.1,0.2), 0.2);
	color += blob(p2, 0.015, 3., 7., vec3(0.4,0.1,0.3), 0.2);
	color += blob(p2, 0.017, 5., 7., vec3(0.4,0.5,0.3), 0.2);

	color += blob(p2, 0.013, 3., 2., vec3(0.1,0.3,0.7), 0.2);
	color += blob(p2, 0.015, 5., 7., vec3(0.4,0.1,0.3), 0.2+cos(time/13.));
	color += blob(p2, 0.017, 2., 3., vec3(0.4,0.5,0.3), 0.2);

	color /= 4.0;

	vec3 back = texture2D(bb, p1*BUFFERZOOM+vec2(0.5,0.5)).rgb*BUFFERFADE;
	color += back;
	vec4 final = vec4(color, 1.0);
	gl_FragColor = final;

}