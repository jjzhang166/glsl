                           
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float alterne(float t){
	return clamp(1.2*sin(t),-0.6,0.6)+1.2;
}

void main(  ) {
	vec2 p =(18.0*( gl_FragCoord.xy / resolution.xy )-9.0) ;
	p.x*=resolution.x/resolution.y;
	vec2 pp=vec2(0.0);
	float a=0.;
	for(int i=0;i<8;i++)
	{
		 a+=0.785;
		 float cf=4.0*alterne(time*0.4+a);
		 vec2 c=cf*vec2(cos(time*0.4+a),sin(time*0.4));
		 pp+=cf*(p-c)/length(p-c);
	}
	pp=abs(normalize(pp));
	vec3 col=1.0-vec3(0.3*exp((pp.x+pp.y)),0.4*exp(pp.y),0.7*exp((pp.x*pp.y)));	
	gl_FragColor = vec4 (col, 1.);
}