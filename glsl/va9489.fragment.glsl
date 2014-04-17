#define PROCESSING_COLOR_SHADER
                           
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float alterne(float t){
	return clamp(2.0*sin(t),-0.5,1.)+1.0;
}

void main(  ) {
	vec2 p =(8.0*( gl_FragCoord.xy / resolution.xy )-4.0) ;
	p.x*=resolution.x/resolution.y;
	vec2 pp=vec2(0.0);
	float a=0.;
	for(int i=0;i<6;i++)
	{
		 a+=1.0472;
		 float cf=2.0*alterne(time+a);
		 vec2 c=cf*vec2(cos(time*0.2+a),sin(time*0.2+a));
		 pp+=10.*cf*(p-c)/dot(p-c,p-c);
	}
	vec3 col=0.2*clamp(vec3(pow(pp.x+pp.y,pp.x),pow(pp.x*pp.y,pp.x+pp.y) ,pow(pp.x+pp.y,pp.y)),0.0,5.);	
	gl_FragColor = vec4 (col, 1.);
}
