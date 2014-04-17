#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) ;

	float r = 0.0;
	float g = 0.0;
	float b = 0.0;
	r += atan( sin(position.y*0.1+time*0.1)+cos(position.y*0.2+time*0.1), sin(position.x*0.2+time*0.2)*sin(position.x*0.3+time*0.5) ) * 0.5;
	r -= atan( sin(position.x*10.0+time/4.0), sin(position.y*10.0+time/3.0) ) * 0.5;
	g -= atan( sin(position.y*0.1+time*0.1)+cos(position.y*0.2+time*0.1), sin(position.x*0.2+time*0.2)*sin(position.x*0.3+time*0.5) ) * 0.5;
	g += atan( sin(position.x*30.0+time/4.0), sin(position.y*20.0+time/3.0) ) * 0.5;
	b -= atan( sin(position.y*0.1+time*0.2)+cos(position.y*0.2+time*0.1), sin(position.x*0.2+time*0.2)*sin(position.x*0.3+time*0.5) ) * 0.5;
	b += atan( sin(position.x*30.0+time/4.0), sin(position.y*20.0+time/3.0) ) * 0.5;

	gl_FragColor = vec4( vec3( r*b/g, g*g/r , b*g/r ), 1.0 );

}