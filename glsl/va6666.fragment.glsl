#pragma 6666

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;

float stime=sin(time);
float ctime=cos(time);
float udBox( vec3 p, vec3 b )
{
  return length(max(abs(p)-b,0.0));
}
float udBox1( vec3 p, vec3 b )
{
  return dot(max(abs(p)-b,0.0),vec3(1./3.));
}
float udBox2( vec3 p, vec3 b )
{
  return dot(abs(p)-b,vec3(1./3.));
}
float inObj(in vec3 p){
	return min(udBox(p, vec3(1.0)), min(udBox1(p, vec3(1.0)), udBox2(p, vec3(1.0))));
	//float oP=length(p);
	//p.x=sin(p.x)+stime;
	//p.z=sin(p.z)+ctime;
	//return float(min(length(p)-1.5-sin(oP-time*4.0),p.y+3.0));
}


void main(void){
	vec2 vPos=-1.0+2.0*gl_FragCoord.xy/resolution.xy;

	vec3 vuv=vec3(stime,1,0);
	vec3 vrp=vec3(sin(time*0.7)*10.0,0,cos(time*0.9)*10.0);
	vec3 prp=vec3(sin(time*0.7)*20.0+vrp.x+20.0,
				  stime*4.0+4.0+vrp.y+3.0,
				  cos(time*0.6)*20.0+vrp.z+14.0);

	vec3 vpn=normalize(vrp-prp);
	vec3 u=normalize(cross(vuv,vpn));
	vec3 v=cross(vpn,u);
	vec3 vcv=(prp+vpn);
	vec3 scrCoord=vcv+vPos.x*u*resolution.x/resolution.y+vPos.y*v;
	vec3 scp=normalize(scrCoord-prp);

	const vec3 e = vec3(0.1,0,0);
	const float maxd=200.0;

	float s=0.1;
	vec3 c,p,n;

	float f=-(prp.y-2.5)/scp.y;
	if (f>0.0) p=prp+scp*f;
	else f=maxd;

	for(int i=0;i<256;i++){
		if (abs(s)<.01||f>maxd) break;
		f+=s;
		p=prp+scp*f;
		s=inObj(p);
	}

	if (f<maxd){
		if(p.y<-2.5){
			c=vec3(0,0,0);
			n=vec3(0,0,0);
		}
		else{
			float d=length(p);
			c=vec3((sin(d-time*4.0)+1.0)/4.0,
				   (sin(d-time*4.0)+1.0)/4.0,
				   (sin(d-time*4.0)+1.0)/2.0);
			n=normalize(
						vec3(s-inObj(p-e.xyy),
							 s-inObj(p-e.yxy),
							 s-inObj(p-e.yyx)));
		}
		float b=dot(n,normalize(prp-p));
		gl_FragColor=vec4((b*vec3(1.)+pow(b,54.0))*(1.0-f*.005),1.0);
	}
	else gl_FragColor=vec4(0,0,0,1);
}
