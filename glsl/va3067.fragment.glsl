// @rotwang: simple grid using mod

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	float aspect = resolution.x / resolution.y;
	vec2 unipos = gl_FragCoord.xy / resolution;
	//unipos.x *= aspect;

	vec3 rgb = vec3(0.9);

	float divs = 90;
	
	
	
	
	
	
	// vertical lines
	float th = 0.01;
	float thx = th/aspect;
	float rx = 1.0-thx;
	rx /= divs;
	if (mod(unipos.x+unipos.y, rx) < thx )
		rgb = vec3(0.3);
	
	// horizontal lines
	float ry = 1.0-th;
	ry /= divs;
	if (mod(unipos.y-unipos.x*cos(unipos.x*0.8)*3.0 , ry) < th )
		rgb = vec3(0.3);
	

	gl_FragColor = vec4( rgb, 1.0);

}