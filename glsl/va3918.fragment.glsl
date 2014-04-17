#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 sincostime( vec2 p ){
	p.x=p.x+sin(p.x*2.0+time)*0.4-cos(p.y*1.0-time)*0.5-sin(p.x*3.0+time)*0.3+cos(p.y*3.0-time)*0.1;
	p.y=p.y+sin(p.x*5.0+time)*0.7+cos(p.y*8.0-time)*0.3+sin(p.x*4.0+time)*0.5-cos(p.y*6.0-time)*0.3;
	return p;
}


void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	position=sincostime(position);
	
	float color = 0.0;
	color += sin( position.x * cos( time / 50.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
	color += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
	color += sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	color *= sin( time / 10.0 ) * 0.5;

	gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );

}