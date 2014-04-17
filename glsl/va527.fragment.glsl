// By Antonino Perricone

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) 
{
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
  	vec4 exPixel = texture2D(backbuffer, position ) * 0.9;
  	vec2 delta = position - mouse;
  	delta.x *= resolution.x / resolution.y;
  	float dMouse = length(delta) * 75.;
  	if( dMouse < 1. )
          exPixel = mix(vec4(1,0,0,1),exPixel,dMouse);

	//exPixel.x = mouse.x - position.x;
  	//exPixel.y = mouse.y - position.y;
  	//exPixel.y = position.x;
	gl_FragColor = exPixel;

}