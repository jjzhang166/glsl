#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = (gl_FragCoord.xy / resolution.xy);
	p.x *= resolution.x/resolution.y;
	
	vec3 c = vec3(1,0,0);
	
	float bordervaly = mod(p.y,0.1);
	float borderposy = mod(floor(p.y/0.1),2.);
	
	if (bordervaly >= 0. && bordervaly <= 0.01){
		c.x = 0.;	
	}
	if (borderposy != 0.)
		p.x += 0.15;	
	
	float bordervalx = mod(p.x ,0.3);
	if (bordervalx >= 0. && bordervalx <= 0.01)
	 c.x = 0.;
	
	gl_FragColor = vec4(c,0);

}