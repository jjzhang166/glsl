#ifdef GL_ES
precision highp float;
#endif
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float nne = 52.0;
float makePoint(float x,float y,float fx,float fy,float sx,float sy,float t){
   float xx=x+cos(t*fx)*sx;
   float yy=y+sin(t*fy)*sy;

   return 1.0/sqrt(xx*xx+yy*yy);
}
float makePoint(float x,float y,float fx,float fy,float sx,float sy,float t,float offset){
   float xx=x+cos(t*fx+offset)*sx;
   float yy=y+sin(t*fy+offset)*sy;

   return 1.0/sqrt(xx*xx+yy*yy);
}
float orbiter(float x,float y,float fx,float fy,float sx,float sy,float t,float offset){
	float standardSize=500.1;
	float speedS=0.15;
   float xx=x+cos(t*fx+offset)*sx-(speedS*sin(t*standardSize));
   float yy=y+sin(t*fy+offset)*sy-(speedS*cos(t*standardSize));
	//x(θ)=d cos θ+ cos pθ ; y(θ)=d sin θ+ sin pθ	
	//X(T) = sin(T)cos(-7*T/16) - 1/4 * cos(T)sin(-7*T/16)
	//Y(T) = sin(T)sin(-7*T/16) + 1/4 * cos(T)cos(-7*T/16)
	return 1.0/sqrt(xx*xx+yy*yy);}	
float FunkyP(float x,float y,float fx,float fy,float sx,float sy,float t){
   float xx=x+sin(time)*sx*cos(-7.0*time/16.0)-1.0/4.0*cos(time)*fx*sin(-7.0*time/16.0);
   float yy=y+sin(time)*sy*sin(-7.0*time/16.0)-1.0/4.0*cos(time)*fy*cos(-7.0*time/16.0);	
	

   return 1.0/sqrt(xx*xx+yy*yy);
}
//float orbitPoint(float x, float y, );


void main( void ) {

   vec2 p=(gl_FragCoord.xy/resolution.x)*2.0-vec2(1.0,resolution.y/resolution.x);

   p=p*10.0;
   
   float x=p.x;
   float y=p.y;

	
   float a=
       makePoint(x,y,1.0,1.0,1.0,1.0,time,0.0);
	//a+=FunkyP(x,y,5.0,5.0,5.0,5.0,time);
  
   float b=
       makePoint(x,y,1.0,1.0,1.0,1.0,time,90.0);
	

   float c=
       makePoint(x,y,1.0,1.0,1.0,1.0,time,180.0);

   float g;
   float f=
       makePoint(x,y,0.0,0.0,0.0,0.0,time);
	makePoint(x,y,0.0,0.0,0.0,0.0,time);
	makePoint(x,y,0.0,0.0,0.0,0.0,time);
	for(float lp=0.0;lp<20.0;lp++){
		float oS=30.0;
		f+=makePoint(x,y,lp,lp,oS/lp,oS/lp,time/20.0);
		g+=orbiter(x,y,lp,lp,oS/lp,oS/lp,time/20.0,0.0);
	}

   float SUNF=	makePoint(x,y,0.0,0.0,0.0,0.0,time);
	   
	
   vec3 d=vec3(a,b,c)/4.0;
	
   vec3 e=vec3(f)/40.0;
   vec3 moons=vec3(g)/400.0;
   vec3 SUN=vec3(SUNF)/4.0; 
	
   gl_FragColor = vec4(d.x,d.y,d.z,6.0)+vec4(e.x,e.y,e.z,1.0)+vec4(moons.x,moons.y,moons.z*1.2,1.0)+vec4(SUN.x*sin(time+90.0),SUN.y*cos(time),SUN.z*sin(time),1.0);
}