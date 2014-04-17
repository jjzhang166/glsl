#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float random(float a,float b) {
    return fract(sin(dot(vec2(a,b) ,vec2(12.9898,78.233))) * 43758.5453);
}

void main( void ) {
// + mouse / 4.0
	vec2 pos = ( gl_FragCoord.xy / resolution.xy );
	float aspect = resolution.x / resolution.y;
	//vec3 color = vec3(1,1,1) / sqrt(pos.x*pos.x + pos.y*pos.y);
	//vec3 ns = noise3(123);
	float dist = sqrt(((pos.x - mouse.x)*(pos.x - mouse.x)) + ((pos.y - mouse.y)*(pos.y - mouse.y))) * random(pos.x, pos.y);
	dist *= aspect;
	dist *= 2.;
	vec3 color = vec3(1.0, 1.0, 1.0) - dist;
	color *= mod(gl_FragCoord.x, 2.);
	color *= mod(gl_FragCoord.y, 2.);
	gl_FragColor = vec4(color, 0);

}