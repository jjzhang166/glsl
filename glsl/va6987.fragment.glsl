
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

 vec2 position = ( gl_FragCoord.xy / resolution.xy );

float y = time*0.1;
y = y-floor(y);
 
float Range = 0.01;	
float x = 1.0-min(abs(position.y-y)/Range, 1.0);
 gl_FragColor = vec4( 0.0, x, 1.0, 1.0 );

}