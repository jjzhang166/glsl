#ifdef GL_ES
precision mediump float;
#endif
//#define MOUSE
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
	pos.x *= aspect;
	
	#ifdef MOUSE
	vec2 m2 = vec2(mouse.x*aspect, mouse.y);
	#else
	vec2 m2 = vec2(0.5 * aspect, 0.5);
	#endif
	
	//vec3 color = vec3(1,1,1) / sqrt(pos.x*pos.x + pos.y*pos.y);
	//vec3 ns = noise3(123);
	float dist = sqrt(
		((pos.x - m2.x)*(pos.x - m2.x)) + ((pos.y - m2.y)*(pos.y - m2.y))) * random(pos.x, pos.y);
	dist *= 4.;
	vec3 color = vec3(1.0, 1.0, 1.0);
	
	float f;
	if(dist < 0.5) {
		color -= dist;
		color *= mod(gl_FragCoord.x, 2.);
		color *= mod(gl_FragCoord.y, 2.);
		
		f = smoothstep(0.0, 0.8, dist);
		color *= f;
	}
	if(mod(gl_FragCoord.x, 2.) == 0.) {
		//color += vec3(1.2, 0.0, 0.0);
		color = vec3(0.0, 1.0, 0.0);
	}
	
	gl_FragColor = vec4(color, 0);

}