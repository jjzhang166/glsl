#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159

uniform float time;

vec3 pattern(vec2 p,vec2 r)
{
	p = mod(p,r)/r-0.5;
	float c = abs(p.x)+abs(p.y);
	c = abs((c)-0.5)*2.;
	c = abs(c-0.5*2.);
	vec3 col = vec3(0.5,0.25,0)*clamp(pow(1.0-c,0.25),0.0,0.25)*4.0;
	c = (1.0-pow(c,4.0))*4.0;
	return vec3(col*c);
}

void main( void ) {

	vec2 p = ( gl_FragCoord.xy);

	vec3 color = pattern(p,vec2(32.,64.));
	
	gl_FragColor = vec4( color, 1.0 );

}