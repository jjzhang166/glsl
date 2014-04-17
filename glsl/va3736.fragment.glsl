#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;
#define GRADIENT(s, n) (cos((position.y + position.x) * (s) * 4.0 + time * (n)) * 0.5 + 0.5)
void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	vec3 col = vec3(0.0);
	
	if (position.y > 0.99|| position.x > 0.99 || position.x < 0.01 || position.y < 0.01)
		col = vec3(GRADIENT(15.0, 2.0) * GRADIENT(5.0, -1.0) + GRADIENT(12.0, 5.0) * 0.2, (GRADIENT(15.0, 2.0) * GRADIENT(5.0, -1.0) + GRADIENT(12.0, 5.0) * 0.2) * GRADIENT(10.0, 3.0) * 0.4, (GRADIENT(15.0, 2.0) * GRADIENT(5.0, -1.0) + GRADIENT(12.0, 5.0) * 0.2) * GRADIENT(10.0, 3.0) * 0.2 * GRADIENT(20.0, 2.0));
	else
	{
		float speed = sin(position.y * 5.0 + time) * 4.0 + 3.0 + cos(position.x * 4.0 - time * 0.5) * 0.2;
		col = texture2D(backbuffer, position.xy + vec2(speed * 0.001, sin(position.x + sin(position.y - time * 0.3) + time * 0.3) * 0.01)).rgb;
	}
	
	gl_FragColor = vec4(col, 1.0);

}