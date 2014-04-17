#ifdef GL_ES
precision highp float;
#endif
uniform float time;
uniform vec2 resolution;

void main(void)
{	
	vec2 p =8.0*( gl_FragCoord.xy / resolution.xy)-4.0;
	vec2 ti=sqrt(time)*vec2(cos(time*0.4),sin(time*0.4));
	for(int i=1;i<60;i++) {p+=vec2(cos((p.y-ti.x))*sin(p.y-ti.x),sin(float(i)*cos(p.x-ti.y)))/float(i);}
	gl_FragColor=vec4(0.5*sin(3.0*p.x)+0.5,0.5*sin(3.0*p.y)+0.5,sin(p.x+p.y), 1.0);
}
