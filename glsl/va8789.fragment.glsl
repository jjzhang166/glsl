// Thematica
#ifdef GL_ES
precision mediump float;
#endif
#define PROCESSING_COLOR_SHADER
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

vec2 pos;
  	 pos.x =( 2.0 * gl_FragCoord.x )/ resolution.x  -2.0*mouse.x ;
  	 pos.y=(-2.0 * gl_FragCoord.y )/ resolution.y +2.0*mouse.y; 
	vec2 dir = normalize(pos);
	pos.x +=(dir .x*cos(time*0.5)-dir.y*cos(time));
	pos.y +=(-dir.x * sin(time*mouse.x)+dir.y*sin(time*mouse.y));
	gl_FragColor = vec4( pos.x+sin(pos.x) ,abs(sin(pos.y)),abs(pos.x*pos.y), 1.0 );
}