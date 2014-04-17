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
	float h = b*b - 4.0*c;
	
	if(h<0.0) return -1.0;
	
	float t = (-b * sqrt(h))/2.0;
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
	
	vec3 ro=vec3(0.0, 1.0,-5.0);
	vec3 rd=normalize(vec3(-1.0+2.0*uv, 1.0));
	
	float ir = intersect(ro,rd);
	
	// we hit something
	if(ir > 0.0)
	{
		
		
		color = vec3(0.2)*uv.x*uv.y;
	}
	
	
	color *= 119.0;
	
	gl_FragColor = vec4(color,1.0) * sin(color.x*time*color.y*time*color.z);

}