#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 middle = position - vec2(0.5,0.5);
	float ratio = resolution.y/resolution.x;
	float dist = sqrt(middle.x*middle.x + middle.y*middle.y*ratio*ratio);
	float color = 0.0;
	float size = 15.0;
	color += 1.0-mod(abs( (time+10.0)/size - dist )*size , 1.0);
	dist *= 3.0;
	color = color * color *.2 * (1.0-sin(dist));
	gl_FragColor = vec4( vec3( color, color , color ), 1.0 );

}