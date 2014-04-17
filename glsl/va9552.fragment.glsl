#ifdef GL_ES
precision mediump float;
#endif

//Ash
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main() {

	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	p-=.5;

	vec4 col;

	for(int i=0;i<1;i++)
	{
		p.y+=.5*sin(p.x*1.+time*10.0*mouse);
		float f1 = (1.00-1.*abs(p.y));
		float f2 = pow(1.*f1,80.);
		col += vec4(f2,f2*sin(time*float(i+1)*p.x),f2*sin(time*float(i+1)*p.x*10.),f2);
	}
	
	gl_FragColor = col;

}