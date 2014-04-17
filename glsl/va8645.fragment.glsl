#// Inspiration: Birdie demo workshop example : http://glsl.heroku.com/e#8617.0
//  Thematica
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


vec3 roty(vec3 v){
	float tm=time+v.y*5.0*sin(time*0.2);
	float c=cos(tm);
	float s=sin(tm);
	mat3 m=mat3(c,0.0,-s,0.0,1.0,0.0,s,0.0,c);
return m*v;
}


float pToOctaedre(vec3 p){
	float haut=1.3;
	float cote=0.8;
	p=roty(p);
	vec3 pa=abs(p);		
		pa.z=max(abs(p.x),abs(p.z));
		pa.x=min(abs(p.x),abs(p.z));
		float op=length(p.xz);
		vec2 nor=normalize(vec2(haut,op*cote/pa.z));
		vec2 ap=vec2(op,pa.y-haut );		
		return dot(ap,nor)-0.2;

}
vec3 laNormale(in vec3 p)
{	float e=0.0001;
	vec3 ex = vec3(e, 0.0, 0.0); 
	vec3 ey = vec3(0.0, e, 0.0); 
	vec3 ez = vec3(0.0, 0.0, e); 
	float nx = pToOctaedre(p + ex) - pToOctaedre(p - ex);
	float ny = pToOctaedre(p + ey) - pToOctaedre(p - ey);
	float nz = pToOctaedre(p + ez) - pToOctaedre(p - ez);
	return normalize(vec3(nx,ny,nz)); 
}
	
void main( void ) {

	vec2 p = 2.0 * ( gl_FragCoord.xy / resolution.xy ) - 1.0;
	p.x *= resolution.x/resolution.y; 
	vec3 color = vec3(0.7,0.0,0.5); 
	
	
	vec3 ro= vec3(0,0,2.0); 
	vec3 rd = normalize(vec3(p.x,p.y,-1.0)); 
	
	vec3 pos = ro; 
	float dist = 0.0; 
	float d = 0.0;
	for (int i = 0; i < 100; i++) {
			
		d = pToOctaedre(pos); 
		pos += rd*d;
		dist += d;
	}
	
	if (dist < 10.0) 
	 {
		color = vec3(1,1,1);
		vec3 n = laNormale(pos); 
		vec3 l = normalize(vec3(0.5,0.2,1));
		vec3 r = reflect(pos, n); 
		float diff = clamp(dot(n, l), 0.0, 1.0); 
		float spec = pow(clamp(dot(r, normalize(vec3(10,10,10)-pos)),0.0,1.0),32.0); 
		color = vec3(0.2,0.1,0.1) + vec3(0.9,0.2,0.7)*diff ; 
	}
	
	gl_FragColor = vec4(color, 1.0); 

}