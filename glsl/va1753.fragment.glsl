#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	    vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
p.y *= resolution.y/resolution.x;
    vec2 m = -1.0 + 2.0 * mouse.xy / resolution.xy;
m *=10.0;
float t = time*3.0;
    float a = atan(p.y,p.x );
    float r = length(p);
float sd = sign(r-0.5);
	vec3 tc=vec3(0.0,0.0,0.0);
	for( int s=0;s<10;s++)
	{
	float c = sin(r*70.*sin(t+float(s)*0.005) + sin(sin(a*4.0)*7.0)*0.5 ) >0. ? 0. : 1.0;
		// tc +=c;
		float rs = float(s)/10.0 * 3.1415 * 2.0;
		tc += c*(0.5+0.5*cos(vec3(rs+1.0,rs+0.5,rs)));
	}
//	tc = mod(tc,2.0)*0.5;
	tc /= 10.0;
    gl_FragColor = vec4(tc,1.0);


}