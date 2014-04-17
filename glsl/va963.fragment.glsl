#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p =  gl_FragCoord.xy / resolution.xy * 2.0 - 1.0;

	float color = 0.0;
	color = atan( p.y, p.x)/3.1416;
	float r = sqrt(dot(p, p));

	if(mod(r,0.1)>0.05)
	  gl_FragColor = vec4( r, 0.0, 0.0, 1.0 );
	else
	  gl_FragColor = vec4( r, 1.0, 0.0, 1.0 );

}