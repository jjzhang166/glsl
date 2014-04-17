#ifdef GL_ES
precision mediump float;
#endif

// dashxdr Turing Patterns
// move mouse to the right to randomize

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D bb;

float rand(float v)
{
	return fract(sin(v*.976)*15.1725 - cos(v*.171)*11.29958);
}

void main( void ) {

	float n = gl_FragCoord.y * resolution.x + gl_FragCoord.x;
	if(mouse.x > .95 || time<.8)
	{
		gl_FragColor = vec4(vec3(rand(n+time)), 1.0);
		return;
	}
	float sum=0.0;
	vec2 position = gl_FragCoord.xy / resolution.xy;

	n+=time;
	for(int i=0;i<8;++i)
	{
#define R1 .01
#define R2 .03
		float r = rand(n)*R1;
		float a = rand(n+.1)*3.1415927*2.0;
		sum += texture2D(bb, position+vec2(cos(a)*r, sin(a)*r)).r;
		r = rand(n+.2)*R2;
		a = rand(n+.3)*3.1415927*2.0;
		sum -= texture2D(bb, position+vec2(cos(a)*r, sin(a)*r));
	}
	gl_FragColor = vec4(vec3(texture2D(bb, position).r+sum*.01), 1.0);


}