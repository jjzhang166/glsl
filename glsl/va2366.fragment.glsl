#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = gl_FragCoord.xy;
	vec2 r = resolution.xy;

	float color = 1.0;
	
	color = log(p.x)/16.0;
	color *= log(p.x-r.x)/16.0;
	
	color *= abs(p.y)/16.0;
	color *= abs(p.y-r.y)/16.0;
	
	color += (cos(time)*32.0);
	
	
	
	gl_FragColor = vec4(color,color,color,1.0);

}