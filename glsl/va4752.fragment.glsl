#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//Scene
float o(vec3 p, float s)
{
	return length(p) - s;
}

//Get Normal
vec3 gn(vec3 q, float s)
{
 vec3 f=vec3(.01,0,0);
 return normalize(vec3(o(q+f.xyy,s),o(q+f.yxy,s),o(q+f.yyx,s)));
}

void main( void ) {

	vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
	p.x *= resolution.x/resolution.y;
	
	vec4 c=vec4(1.0);
	
	vec3 org=vec3(sin(time)*.5,cos(time*.5)*.25+.25,time);
	vec3 dir=normalize(vec3(p.x*1.6,p.y,1.0));
	vec3 q=org;
	vec3 pp;
 	float d=.0;
	
	//First raymarching
	for(int i=0;i<64;i++)
	{
		d=o(q, 0.25);
		q+=d*dir;
	}
	
	pp=q;
	float f=length(q-org)*0.02;
	
	//Second raymarching (reflection)
	 dir=reflect(dir,gn(q , 0.25));
	 q+=dir;
	 for(int i=0;i<64;i++)
	 {
		 d=o(q, 0.25);
		 q+=d*dir;
	 }
	
	 //Final Color
	 vec4 fcolor = ((c+vec4(f))+(1.-min(pp.y+1.9,1.))*vec4(1.,.8,.7,1.))*min(time*.5,1.);
	 gl_FragColor=vec4(fcolor.xyz,1.0);
	//gl_FragColor = vec4(f,0.0,0.0, 1.0 );
	//gl_FragColor = vec4(p,0.0, 1.0 );

}