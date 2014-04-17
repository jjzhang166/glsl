#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 color;
vec2 uv;

// basic attempt to raytracing, with help of some tutorials.

float iSphere( vec3 ro, vec3 rd )
{
	float r = 2.0;
	float b = 2.0*dot(rd,ro);
	float c = dot(ro,ro) - r*r;
	float h = b*b - 2.0*c;
	
	if(h<0.0) return -1.0;
	
	float t = (-b + h)/2.0;
	return t;
}

float iPlane( vec3 ro, vec3 rd )
{
	float r = 1.0;
	float b = -rd.y/ro.y;
	b += rd.x*rd.x*cos(time);
	
	
	return b;
}

float intersect( vec3 ro, vec3 rd )
{
       float t = iSphere(ro,rd);
	float t2 = iPlane(ro,rd);
	float t3 = iSphere(ro,rd);

	float v;
	
	if(t > 0.0)
	{
		v=1.0 ;
	}
	
	if(t2 > 0.0)
	{
	 	v+=t2 ;

	}
	
       return v;
}

void main( void ) {

	uv = ( gl_FragCoord.xy / resolution.xy ) * vec2(1.2, 1.0);

	color = vec3(0.0);
	
	vec3 ro=vec3(0.0, 1.0, 4.0);
	vec3 rd=normalize(vec3(-2.6+4.0*uv*vec2(1.2,1.0), 0.5));
	
	float ir = intersect(ro,rd);
	
	// we hit something
	if(ir > 0.0)
	{
	
			color = vec3(0.1) + ir * vec3(1.0, 0.0, 0.0);
	
	
	}
	
	
	gl_FragColor = vec4(color,1.0);

}