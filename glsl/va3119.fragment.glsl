// @rotwang

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


void main( void ) {
	
	float aspect = resolution.x / resolution.y;
	vec2 unipos = gl_FragCoord.xy / resolution;
	vec2 pos = unipos*2.0-1.0;
 	//pos.x *= aspect;

	vec2 apos = abs(pos);
	float shade = 0.33;
	
	float dx = 12.0 * apos.x + time;
	float sdx = sin(dx);
	shade += sdx*0.5;


	float dy = 12.0 * apos.y + time;
	float sdy = sin(dy);
	shade += sdy*0.5;
	
	
	gl_FragColor = vec4( vec3(shade), 1.0);

}