#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float orbitDistance = 0.025;
float waveLength = 100.;

float intersects(in vec3 ro, in vec3 rd) {
	
	
	return 1.0;
	
	
}

vec3 raytrace(in vec3 ro, in vec3 rd) {
	return ro;
}

void main( void ) {
	//Texture coords
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	
	//Create a ray
	vec3 ro = vec3(mouse.x, mouse.y + 2.0, 4.0);
	vec3 rd = normalize( vec3( -1.0 + 2.0*uv* vec2(resolution.x/resolution.y, 1.0), -1.0 ) );
	
	//Raytrace
	vec3 color = raytrace(ro, rd);
	
	//Draw!
	gl_FragColor = vec4(color, 0.0);
}