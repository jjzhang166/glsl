#ifdef GL_ES
precision highp float;
#endif
uniform float time;
uniform vec2 resolution;

void main(void)

{       vec2 p =12.0*( gl_FragCoord.xy / resolution.xy)-6.0;
	vec2 ti=sqrt(time)*vec2(cos(time*0.1),sin(time*0.1));
	for(int i=1;i<20;i++) 
	{p+=vec2(cos((p.y-ti.x))*sin(p.y*ti.x),
        sin(float(i)+cos(p.x+ti.y)))/float(i);}
	gl_FragColor=vec4(0.1*sin(6.0*p.x)+0.7,0.1*cos(12.0*p.y)-0.5,atan(p.x+p.y), 1.0);
}
