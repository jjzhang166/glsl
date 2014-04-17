#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float sphere(vec3 pos,vec3 spherepos,vec3 lightpos,float r)
{
	float rel = distance(pos,spherepos);

	if (rel<r)
	{
		if (lightpos.x<-10.0) //dummy sphere for lights themselves
			return 1.0;
		
		pos.z=cos(1.*rel/r)*r;
		//return length(pos.z);
		//vec3 normal = normalize(pos-spherepos)*cos(3.*distance(pos,spherepos)/r);
		vec3 normal = normalize(pos-spherepos)*cos(rel/r);

		vec3 lightdir = normalize(lightpos-spherepos);

		return dot(normal,lightdir)/(4.*pow(distance(lightpos,pos),2.0));

	}
	else
		return 0.0;
}

void main( void ) {

	vec3 pos = vec3((gl_FragCoord.x + resolution.y-resolution.x)/ resolution.y , gl_FragCoord.y / resolution.y,0.0);
	
	vec3 lpos = vec3(mouse.x*resolution.x/resolution.y+(resolution.y-resolution.x)/resolution.y,mouse.y,+0.4);
	float color = 0.0;
	
	vec3 spos=vec3(0.5,0.5,0.0);
	//vec2 lpos=vec2(0.9,0.9);
	
	//sphere
	color = sphere(pos,spos,lpos,0.3);
	
	//light marker
	color += sphere(pos,lpos,vec3(-20.0,0.0,0.0),0.02);

	
	//gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );
	gl_FragColor = vec4(color,color,color,0.0);

}