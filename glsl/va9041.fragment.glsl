#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float field(vec3 p){	
	vec3 pp = vec3(mod(p.x,20.0)-10.0,mod(p.y,20.0)-10.0,p.z);
	float m = sin(pp.x*2.8+time)*sin(sin(pp.y)*2.2+5.1)*sin(pp.z*2.0+time)*0.5;	
	return (length(pp-vec3(sin(time),sin(time),-15.0))-5.0-m);
}

void main( void ) {

	vec2 r = ( gl_FragCoord.xy / resolution.xy )-0.5 ;
	
	float t = 0.0;
	vec3 d = normalize(vec3(r.x,r.y,-1.0));
	vec3 c = vec3(mouse.x*30.0,mouse.y*30.0,0.0);
	vec3 p = c;
	
	for(int i = 0; i < 50; i++){
		t = field(p);
		p += d * clamp(t,-1.0,1.0);
	}
	
	float f = distance(p,c)*0.04 ;
	float a = max(0.0,field(p+d.xyz))+max(0.0,field(p+d.yzx))+max(0.0,field(p+d.zxy));
		
	gl_FragColor = vec4( sin(f+time),cos(f-time),sin(f+0.3*time)*cos(f-0.15*time),1.0);

}