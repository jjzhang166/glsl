// Best viewed with 0.5
// rotwang: like! @mod* just playing
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy ) ;
	vec3 c;
	c = vec3(mod(pos.y + (time + cos(pos.y * 8.0) + sin(pos.x * 1.0)) * 0.1, 0.05) > 0.04) * 0.2;
	c.r += pos.y * 0.25;
	c.g += pos.x * pos.x + sin(time + pos.y + 2.1) * 0.25;
	c.b += pos.x + sin(time + pos.x) * 0.25;	
	c *= pow(pos.y, 0.9);
	gl_FragColor = vec4(c, 1.0);
}