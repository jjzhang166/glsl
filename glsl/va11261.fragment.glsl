#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 res;

float height(vec2 p)
{
	p.x -= res.x/4.;

	float c = 0.0;
	
	for(float i = 0.;i < 8.;i++)
	{
		for(float j = 0.;j < 8.;j++)
		{
			float s = clamp(1.-distance(p,vec2(i+sin(0.5*time+j),j+cos(0.5*time-i))/8.)*4.,0.,1.);
			c = abs(c-s);
		}
	}
	
	return c;
}

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

float mars(in vec3 pos, in vec3 dir, inout vec3 result)
{
	float res = 0.0;
	vec3 p = pos;
	#define steps 100.0
	#define step (1.0/steps)
	
	for (float i=0.0;i<steps;i++) {
		p += dir * step;
		if (height(p.xy) > p.z) {
			break;	
		}
		
		res += 1.0/steps;
	}
	
	return res;
}

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	vec2 res = vec2(1.,1.);
	
	float c = height(p);
	float u = height(p+vec2(0,2)/resolution);
	float r = height(p+vec2(2,0)/resolution);
	//c = 1.-pow(c,0.2);
	vec2 size = vec2(-0.02,0.0);
	//vec3 n = cross(normalize(vec3(size.yx,c-u)),normalize(vec3(size.xy,c-r)));
	vec3 n = cross(normalize(vec3(size.yx,c-u)),normalize(vec3(size.xy,c-r)));
	//n.z = abs(n.z);
	vec3 mars_end;
	float dist = mars(vec3(p, 1.0), normalize(vec3(cos(time*0.6), sin(time*0.5), -5.0)), mars_end);
	vec3 col = hsv2rgb(vec3(0.5+dist*0.2 + p.y*0.2, (1.0-dist)*0.5+0.5, 1.0-dist));
	

	gl_FragColor = vec4( col, 1.0 );

}