#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float distancia(vec2 p1, vec2 p2){
	float x = p1.x-p2.x;
	float y = p1.y-p2.y;
	return sqrt((x*x)+(y*y));
}

void main( void ) {
	float dist = distancia(gl_FragCoord.xy, resolution / 2.0);
	dist /= resolution.x;
	vec3 color;
	if (dist < 0.14) {color = smoothstep(0.0, 0.1, 1.0) * vec3(1.0, 1.0, .6);}
	else {color = (time/1.0)*vec3(1, 0.5,0.0);}
	gl_FragColor = vec4(color, 1.0);
}