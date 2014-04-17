#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec4 sphere(vec3 pos,vec3 spherepos, float r, vec3 lightpos, vec4 colz, bool fullbright)
{
	vec2 inspherepos=-(pos.z-spherepos.z)*(pos.xy-spherepos.xy)/r;
	float scol=0.;

	if(length(inspherepos) < r && (spherepos.z<colz.w))
	{
		if(fullbright==true)
		{	
			colz=vec4(1.0,1.0,1.0,spherepos.z);
		}
		else
		{
			vec3 normal=normalize(vec3(inspherepos.xy,-1.+inspherepos.x*inspherepos.x+inspherepos.y*inspherepos.y)); //not entirely correct
			vec3 lightdir=normalize(spherepos-lightpos);
			float intensity=pow(3.*length(spherepos-lightpos),-2.0);
			scol=intensity*dot(-lightdir,normal);
			colz=vec4(scol,scol,scol,spherepos.z);
		}
	}
	return colz;
}

void main( void ) {

	vec3 position = vec3( ( (gl_FragCoord.xy) / resolution.y ),0.0)-0.5;
	vec3 spherepos=vec3(0.2+0.*sin(time)*.5,-0.0+0.*cos(time),0.1*sin(0.3*time)+1.);
	vec3 lightpos=vec3(0.2+sin(0.2*time)*.5,0.0+0.3*cos(time),0.+0.3*sin(time)+0.89);
	float r=0.5;
	vec3 normal;
	vec4 colorvecz=vec4(.2,.0,.0,20.);
	
	colorvecz = sphere(position,spherepos,r,lightpos,colorvecz,false);

	colorvecz = sphere(position,lightpos,0.15,lightpos,colorvecz,true);

	colorvecz = sphere(position,spherepos+vec3(0.5,0.1,0.5),r,lightpos,colorvecz,false);
	colorvecz = sphere(position,spherepos+vec3(0.4,-0.2,-0.5),r,lightpos,colorvecz,false);

	gl_FragColor = vec4( colorvecz.xyz, 5.0 );

}