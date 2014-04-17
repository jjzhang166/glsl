#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 calcJulia(vec2 position2, float zoffset, float juliaoffset) {
vec3 res=vec3(0,0,0);
       float p=juliaoffset; //*50.26; // pi*16
        float sc=0.2;
//float p=1.,sc=1.;
        sc*=8.0; // this is terrible.  srsly.
        if(sc<4.0)sc=8.0-sc;
        sc-=3.;
        vec4 m0=vec4(cos(p),sin(p)*cos(p),sin(p)*sin(p),0);
        vec4 m1=vec4(-sin(p),cos(p)*cos(p),cos(p)*sin(p),0);
        vec4 m2=vec4(0,-sin(p),cos(p),0);
        vec4 m3=vec4(0,0,0,1);
        mat4 m=mat4(m0, m1,m2,m3);
                for(int zi=0;zi<256;zi+=16) {
                        vec4 v = vec4((0.5-position2.xy)*vec2(5.0,5.0),float(zi-128)/128.0,1.0);
                        v.x*=(v.z+2.0);
                        v.y*=(v.z+2.0);
                        v.x/=sc; v.y/=sc; v*=m;
                        gl_FragColor=vec4(sin(v.x),cos(v.y),0,1);
                        float tx=(atan(v.y,v.x)+3.14)/6.28;
                        float ty=(atan(v.z,v.y)+3.14)/6.28;
                        if(tx<0.5)tx=1.0-tx;
                        if(ty<0.5)ty=1.0-ty;
                        tx=fract(tx*4.);
                        ty=fract(ty*4.);
                        //v.x*=(v.z+1.0);
                        //v.y*=(v.z+1.0);
                        vec4 o=v;
                        // FIXME: start iteration loop
                        for(int jpp=0;jpp<8;jpp++) {
                        float xy2=v.x*v.x+v.y*v.y;
                        float rp=pow(xy2+v.z*v.z, 6.);
                        float alpha=atan(v.y, v.x)*8.0;
                        float beta=atan(v.z, sqrt(xy2))*8.0;
                        v.x=rp*sin(beta)*cos(alpha)+o.x;
                        v.y=rp*sin(beta)*sin(alpha)+o.y;
                        v.z=rp*cos(beta)+o.z;
                        } // end iter loop
                        float r=v.x*v.x+v.y*v.y+v.z*v.z;
                        float dist=sqrt(r)*log(sqrt(r));
                        if(dist<8.0) 
			{res=vec3(float(zi)/256.0,tx,ty);break;}
                }
	return res;
}

void main( void ) {

	float magnify=1.0;
	float zoffset=mouse.y-0.5;
	float juliaoffset=mouse.x-0.5;
	vec2 position2 = gl_FragCoord.xy / resolution.xy;

	vec3 res=calcJulia(position2, zoffset, juliaoffset);
	/*vec3 nx=calcJulia(vec2(position2.x-0.01, position2.y), zoffset, juliaoffset);
	vec3 ny=calcJulia(vec2(position2.x, position2.y-0.01), zoffset, juliaoffset);
	float light=atan((res.z-nx.z), (res.x-nx.x))/3.1415;
	light+=atan((res.z-ny.z), (res.y-ny.y))/3.1415;
	
	light+=0.5;
	//light*=res.z;
	//+abs(res.z-ny.z);

	if(light > 1.0) light=1.0;

	gl_FragColor=vec4(light, light, light,1.0);	*/			
}