#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 tri(vec2 p, float r)
{
	p *= r;
	vec2 x = fract(p);
	vec2 i = p  - x;
	vec3 c = vec3(sin(i.x*2.0), sin(i.y*2.0), 0.0)*0.2+0.2;
	//return ((x.y < x.x) ? 1.0 : 0.0) * c;
	return (((x.x < x.y) == (x.x < 1.0 - x.y)) ? 1.0 : 0.0) * c;
	//return c;
}

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xx );
	p -= mouse;
	float zoom = 1.1 + sin(time*0.5);
	//p *= zoom;
	
	const float r = 20.0;
	vec2 x = fract(p*r);
	vec2 i = p*r - x;
	
	const float w = 50.0;
	float l = clamp(0.0, 1.0, (0.5 - abs(x.x-0.5))*w);
	l *= clamp(0.0, 1.0, (0.5 - abs(x.y-0.5))*w);
	l *= clamp(0.0, 1.0, abs(x.x - x.y)*w);
	l *= clamp(0.0, 1.0, abs(1.0 - x.x - x.y)*w);
	
	//vec3 c = vec3(sin(i.x*0.3), cos(i.y*0.3), 0.0)*0.5+0.5;
	//vec3 c2 = vec3(cos(i.x*0.3), sin(i.y*0.3), 0.0)*0.5+0.5;
	//vec3 tc = mix(c, c2, x.x > x.y ? 1.0 : 0.0);	
	//vec3 tc = mix(c, c2, ((x.y < x.x) == (x.y < 1.0 - x.x)) ? 1.0 : 0.0);
	
	vec3 tc = tri(p, r);
	tc += tri(p, r*0.5);
	tc += tri(p, r*0.25);
	tc += tri(p, r*0.125);
	
	//gl_FragColor = vec4(x, 0.0, 1.0 );	
	//gl_FragColor = vec4(i*0.1, 0, 1);
	//gl_FragColor = vec4(c, 1.0 );
	//gl_FragColor = vec4(vec3(l), 1.0 );	
	gl_FragColor = vec4(tc*l, 1.0 );
}