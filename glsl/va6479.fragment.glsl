#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//alien spectrum :P ~MrOMGWTF

//x = 0...1
//return value = 0...1
float nsin(float x)
{
	return sin(x * 6.28318531) * 0.5 + 0.5;
}

vec3 spectrum(float x)
{
	float t = time * 0.2;
	vec3 c = vec3(0.0);
	c.x = pow(nsin(x * x), 1.21);
	c.y = pow(nsin(x * x + (t)), 1.5);
	c.z = pow(nsin(x - (t)), 0.5);
	return c;
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	gl_FragColor = vec4( spectrum(position.x), 1.0 );

}