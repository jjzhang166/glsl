#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	p-=.5;

	vec4 col;

	for(int i=0;i<2;i++)
	{
		p.y+=.5*sin(p.x*1.+time*5.0);
		float f1 = (1.00-1.*(p.y));
		float f2 = pow(1.*f1,800.);
		col += vec4(f2,f2*sin(time*float(i+1)*p.x),f2*sin(time*float(i+1)*p.x*1.),f2);
	}
	
	gl_FragColor = col;
			   

}