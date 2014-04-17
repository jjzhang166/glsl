//trefle
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 fn(vec3 v,float t){
	 float c=cos(t),s=sin(t);
	 return vec3(c*v.x-s*v.y,s*v.x+c*v.y,v.z*c-s*v.y);
}
mat3 rot(in vec3 axe, in float angle)
{ 
    float s = sin(angle);
    float c = cos(angle);
    float d = 1.0 - c;
    axe = normalize(axe);
    float x=axe.x;
    float y=axe.y;
    float z=axe.z; 
    return  mat3(
   	d * x * x + c      , d * x * y - z * s ,  d * z * x + y * s,
               d * x * y + z * s,  d * y * y + c     ,  d * y * z - x * s,
               d * z * x - y * s ,  d * y * z + x * s,  d * z * z + c      );         
}
vec3 rotate(vec3 v,vec3 axe,float a){
mat3 m=rot(axe,a);
return m*v;
}
void main( void ) {
	vec2 position = 2.0*( gl_FragCoord.xy / resolution.xy ) -1.0;
	position.y*=resolution.y/resolution.x;
	vec3 p=vec3(position,mouse.y);//le vecteur couleur assigné au point courant
	vec3 cc=vec3(cos(time*0.05),sin(time*0.5),sin(time*0.5));// centre1
	vec3 c =rotate( vec3(1.,0.,0.), vec3(cos(time*0.1),sin(time*0.1),cos(0.1*time))-cc,time*0.3 )+cc;//centre2
	 c=rotate(c-p, p,time*0.1)+p;//rotation de c autour de p
	  p=rotate(p- c,c,-time*0.1)+c;//rotation de p autour de c
	 p=(p*p*c-c)*7.0;
	vec3 color=tan(p.zyz*p.xzz*p.xyz);
	gl_FragColor = vec4(color, 1.0 );
}
