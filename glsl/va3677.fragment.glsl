// by rotwang, big pixels

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main( void ) {

	float aspect = resolution.x / resolution.y;
	vec2 unipos = ( gl_FragCoord.xy / resolution );
 	vec2 pos = unipos*2.0-1.0;//bipolar
	pos.x *= aspect;


	vec2 pos_za = floor(pos*8.0);
	vec2 pos_zb = floor(pos*4.0);
	vec2 pos_zc = floor(pos*2.0);

	float a = 1.0-step(0.1, rand(pos_za));
	float b = 1.0-step(0.2, rand(pos_zb));
	float c = 1.0-step(0.4, rand(pos_zc));
	
	vec3 clr_a = vec3(a*0.3, a*0.6, a*0.99);
	vec3 clr_b = vec3(b*0.99, b*0.6, b*0.3);
	vec3 clr_c = vec3(c*0.66, c*0.33, c*0.99);
	
	vec3 clr = clr_a+clr_b-clr_c;
	gl_FragColor = vec4( clr, 1.0 );
	
}