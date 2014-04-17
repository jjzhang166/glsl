#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 unipos = ( gl_FragCoord.xy / resolution.xy );
	
	vec2 centerpos = vec2(cos(time), sin(time));
	vec2 centerpos2 = vec2(cos(time/5.), sin(time/3.+2.));
	vec2 centerpos3 = vec2(cos(time/4.+2.), sin(time/9.+2.));
		//vec2 centerpos = mouse;
	
	
	
	float val1 = cos(8.*(distance(centerpos2, unipos)));
	float val2 = sin(8.*(distance(centerpos.x, unipos.x)));
	float val3 = sin(8.*(distance(centerpos3.y, unipos.y)));
//	float val = (val1 + val2 + val3)/3.;
	float val = (val1 + val2 + val3);
	
	//gl_FragColor = vec4(val, val, val, 1.);
	gl_FragColor = vec4(sin(val+time*5.), cos(val+time*3.), sin(val+.3+time*7.), 1.);
}