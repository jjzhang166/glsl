#ifdef GL_ES
precision mediump float;
#endif

// www.snoep.at was here! coooool site!

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	float r = 0.0;
	float g = 0.0;
	float b = 0.0;
	float sr = sin(position.x+time/200.0)+cos(position.y);
	float sg = asin(position.x)/acos(position.y+time/200.0);
	float sb = atan(position.x,position.y+time/200.0);
	r += sin( position.x * acos( sin(position.y) ) * 30.0 ) + asin(sin( position.x * sin( time / 30.0 ) * 80.0 ));
	g += sin( position.x * asin( sin(position.y/0.300) ) * 30.0 ) + acos(sin( position.x * sin( time / 30.0 ) * 80.0 ));
	b += sin( position.x * asin( sin(position.y) ) * 20.0 ) + acos(sin( position.x * sin( time / 35.0 ) * 80.0 ));
	
	float temp_r;
	float temp_g;
	float temp_b;
	temp_r=r*g/sb;
	temp_g=b*r/sg;
	temp_b=r*g/sr;
	b=b+sin(temp_b)*position.x;
	g=g+cos(temp_g)*position.x;
	r=r+sin(temp_r)*position.y;

	gl_FragColor = vec4( vec3( r, g * 0.5, b ), 1.0 );

}