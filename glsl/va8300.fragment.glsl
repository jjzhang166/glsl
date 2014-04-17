#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float iSphere( vec3 ro, vec3 rd )
{
	float r = 1.0;
	float b = 2.0*dot(rd,ro);
	float c = dot(ro,ro) - r*r;
	float h = b*b - 2.0*c;
	
	if(h<0.0) return -1.0;
	
	float t = (-b + h);
	return t;
}

float intersect( vec3 ro, vec3 rd )
{
       float t = iSphere(ro,rd);

       return t;
}

void main( void ) {

	vec2 uv = ( gl_FragCoord.xy / resolution.xy ) ;

	vec3 color = vec3(0.0);
	
	vec3 ro=vec3(sin(time)*1000.0, 0.0,1000.0);
	vec3 rd=normalize(vec3(-1.0+2.0*uv, 1.0));
	
	float ir = intersect(ro,rd);
	
	vec3 ro2 = vec3(1000.0, 0.0, 1000.0);
	vec3 rd2 = normalize(vec3(-1.0+2.0*uv, 1.0));
	float ir2 = intersect(ro2,rd2);
	
	// we hit something
	if(ir > 0.0)
	{	
		if(ir2 > 0.0)
		{
		color = vec3(0.5)*uv.x*uv.y;
		}
	}
	
	
	color *= 5.0;
	
	gl_FragColor = vec4(color,1.0)*vec4(1.0,0.0,0.0,1.0);

}