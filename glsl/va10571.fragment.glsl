#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 normale(vec2 v){
normalize(v);
return vec2(-v.y,v.x);}



void main( void ) {
	vec2 pos=16.0*(gl_FragCoord.xy/resolution.xy)-8.0;
	//pos.x*=resolution.x/resolution.y:
	vec2 va=vec2(2.0*cos(time),2.0+2.*sin(time));
       	vec2 vb=vec2(-3.0+cos(time*0.2),-2.+2.*sin(time*0.2));
       	vec2 vc=vec2(-8.+0.8*sin(time*1.5),4.0+1.2*cos(time*0.5));
       	vec2 vd=vec2(3.+0.5*cos(-0.3*time),3.0+-0.5*sin(time*1.5));
       	vec2 ve=vec2(4.0+2.*cos(time*1.3),-3.5+0.5*sin(time*1.3));
       	
        vec2 vabn=vec2(-(vb.y-va.y),vb.x-va.x);
        vec2 vacn=vec2(-(vc.y-va.y),vc.x-va.x); 
        vec2 vbdn=vec2(-(vd.y-vb.y),vd.x-vb.x); 
        vec2 vcen=vec2(-(vc.y-ve.y),vc.x-ve.x); 
        
      float d0= (dot(pos-va,vabn));
      float d1=(dot(pos-va,vacn));       
      float d2= dot(pos-vb,vbdn);  
      float d3= dot(pos-vc,vcen);  
      
      gl_FragColor=vec4(pow(d0*d0+cos(d1/d2),d2/d3/d0),pow(d3*d3+cos(d0/d1),d1/d2/d3),pow(d2*d2+sin(d3/d0),d1/d0/d2),1.0);

}