//mu6k
//just messing around with some worse than JPEG artifats

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


vec3 f1(vec3 p)
{
	p=p*8.0;
	p=fract(p);
	p-=mod(p,0.5);
	p+=p.xyz*p.yzx*p.zxy+p.xyz*p.yzx;
	return p;
}

vec3 f0(float t,float q)
{
	
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	
	position-=0.5;
	position*=2.0;
	position-=mod(position+10000.0,1.0/pow(1.4,q+sin(time/8.0+24.0)*8.0+4.0));
	
	vec3 m1 = vec3(position,0.0)-vec3(sin(t*0.22)*sin(t*0.017),sin(t*0.32)*sin(t*0.013),sin(t*0.27)*sin(t*0.0172)*2.0);
	vec3 m2 = vec3(position,0.0)-vec3(sin(t*0.23)*sin(t*0.0153),sin(t*0.33)*sin(t*0.0137),sin(t*0.22)*sin(t*0.017)*2.0);
	vec3 m3 = vec3(position,0.0)-vec3(sin(t*0.27)*sin(t*0.0172),sin(t*0.37)*sin(t*0.0132),sin(t*0.23)*sin(t*0.0153)*2.0);
	vec3 p = vec3(length(m1),length(m2),length(m3));
	return f1(p);
}


vec3 f2(vec3 c)
{
	c*=(sin(gl_FragCoord.y*3.14159*0.5))*0.05+1.0;
	c*=(sin(gl_FragCoord.y*3.14159*0.125))*0.025+1.0;
	c*=(sin(gl_FragCoord.y*3.14159*0.06125))*0.0125+1.0;
	
	
	c*=1.0-length(gl_FragCoord.xy / resolution.xy -0.5)*1.3;
	float w=length(c);
	c=mix(c*vec3(1.0,1.2,1.6),vec3(w,w,w)*vec3(1.4,1.2,1.0),w*1.1-0.2);
	return c;
}

void main( void ) 
{
	vec3 a;
	for (float i=0.0; i<10.0; i+=1.0)
	{
		a+=f0(1.0+time+i/100.0,i+3.0);	
	}
	a/=10.0;
	
	gl_FragColor = vec4(f2(a),1.0);

}