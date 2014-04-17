#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = gl_FragCoord.xy / resolution.xy;

	vec3 color = vec3(0);
	
	float val = tan(sin(p.y*p.x*1e2+time));
	float val2 = tan(sin(p.y*(1.0-p.x)*1e2+time));
	float val3 = tan(sin((1.0-p.y)*p.x*1e2+time));
	color.r = ((val/.3)*.6);
	color.g = ((val2/.3)*.6);
	color.b = ((val3/.3)*.6);
	
	
	gl_FragColor = vec4( color, 1.0 );

}