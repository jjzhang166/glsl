/* @author Alexander Guinness <https://github.com/monolithed>
   @date 28/07/12
*/

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;


vec3 shade(in vec2 position)
{
	float speed = time * 1.6;
 
	position.y = tan(1.0) * length(position);
	float y = cos(position.y * 50.);
	
	return vec3(y / 1.3, y * sin(speed - position.y), .0);
}


void main( void ) 
{
	vec2 position = ((gl_FragCoord.xy / resolution) * 2.0) - 1.0;
	position.x *= resolution.x / resolution.y;
    
	gl_FragColor = vec4(shade(position), 1.0);
}