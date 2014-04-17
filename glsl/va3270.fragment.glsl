/* @author Alexander Guinness <https://github.com/monolithed>
   @date 28/07/12
*/

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
 

void main( void ) {
	vec2 p = (gl_FragCoord.xy / 100.);
	float x = p.x - 2.0;
	float y = p.y - 1.0;

	float a = 1.0 / cos(time + (y * x));
	gl_FragColor = vec4(sqrt(a) / 10.0, .0, .0, .0);

}