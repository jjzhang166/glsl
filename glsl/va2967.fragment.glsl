#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 c = vec2(0.5,0.5);

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy / mouse );
	vec3 color = vec3(0.0);
	float a = atan((p.x-c.x)/(p.y-c.y))+time*0.25;
	float d = sqrt((p.x-c.x)*(p.x-c.x)+(p.y-c.y)*(p.y-c.y));
	color = vec3(abs(sin(a*2.0+sin(d*(sin(time*0.25)*128.0)+time))));
	color = mix(mix(mix(vec3(1.0),vec3(1.0,0.5,0.0),color),vec3(2.0),color),vec3(0.325),d);	
	color *= mix( vec3( sin( d ) ), vec3( d ), sin( d ) );
	gl_FragColor = vec4( color, 1.0 ); 

}