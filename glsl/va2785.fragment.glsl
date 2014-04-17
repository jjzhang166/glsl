//vittu
#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float segmentShape(vec2 p, vec2 s0, vec2 s1, float radius)
{
	vec2 d = normalize(s1 - s0);
	float slen = distance(s0, s1);

	float 	d0 = max(abs(dot(p - s0, d.yx * vec2(-1.0, 1.0))), 0.0),
		d1 = max(abs(dot(p - s0, d) - slen * 0.5) - slen * 0.5, 0.0);

		
	return step(length(vec2(d0, d1)), radius*30.0)*0.008/(length(vec2(d0, d1)));
		
}

void main( void ) {
    	vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;

	
	float l1=.2;
	float angle1=1.*abs(sin(time*1.)*.5);
	float angle2=2.*abs(sin(time*1.)*.5);
	
	
	vec2 o1=vec2(-0.7,-0.7);
	vec2 p1=vec2(0.,0.);
	

	
	vec2 vaderp;
	vaderp.x=(cos(angle1)*(p1.x-o1.x)-sin(angle1)*(p1.y-o1.y))+o1.x;
	vaderp.y=(sin(angle1)*(p1.x-o1.x)+cos(angle1)*(p1.y-o1.y))+o1.y;
	

	
	vec2 yodao=vec2(0.1+0.5*sin(time*4.),sin(time*11.));
	vec2 yodap=vec2(-0.1,0.6);
	angle2=sin(time)*10.5;
	yodap.x=yodao.x+.1*cos(angle2);
	yodap.y=yodao.y+.1*sin(angle2);
	
	
	


	gl_FragColor.a = 1.0;
	gl_FragColor.r = segmentShape(p, o1, vaderp, 5.),0.0,10.0;
	gl_FragColor.g = segmentShape(p, yodao, yodap, 5.),0.0,10.0;
	
		//snakeShape(p, time + 000.0) * vec3(0.1, 0.4, 0.8);
}