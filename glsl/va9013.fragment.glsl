#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float hash( float n )
{
    return fract(sin(n)*43758.5453);
}

float field(vec3 p){	
	vec3 pp = vec3(mod(p.x,20.0)-10.0,mod(p.y,20.0)-10.0,p.z);
	vec3 pos = vec3(sin(time),sin(time),-20.0);
	vec3 n = floor(normalize(pos-pp)*50.0);
	float m = hash(dot(n,n))*1.0;	
	return (distance(pos,pp)-m-4.0);
}

void main( void ) {

	vec2 r = ( gl_FragCoord.xy / resolution.xy )*vec2(1.0,resolution.y/resolution.x)-0.5 ;
	
	float t = 0.0;
	vec3 d = normalize(vec3(r.x,r.y,-1.0));
	vec3 c = vec3(mouse.x*30.0,mouse.y*30.0,0.0);
	vec3 p = c;
	
	for(int i = 0; i < 50; i++){
		t = field(p);
		p += d * clamp(t,-t*0.5,t*0.5);
	}
	
	float f = distance(p,c)*0.04 ;
	float a = max(0.0,field(p+d.xyz))+max(0.0,field(p+d.yzx))+max(0.0,field(p+d.zxy));
		
	gl_FragColor = vec4( mix(vec3(0.0,0.2,0.2),vec3(1.2,1.2,1.2),f*f) * (a*0.9), 1.0 );

}