// Best viewed with 0.5

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) ;
	vec3 c;
	c = vec3(mod(position.x + (time + cos(position.x * 4.0) + sin(position.y * 2.0)) * 0.1, 0.04) > 0.02) * 0.3;
	c.r += position.y;
	c.g += position.y * position.y+ sin(time * 2.0 + position.x * 6.0) * 0.1;
	c.b += pow(position.y + sin(time + position.x) * 0.1, 5.0);
	c *= pow(position.y, 0.2);
	gl_FragColor = vec4(c, 1.0);
}