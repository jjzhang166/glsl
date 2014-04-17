#ifdef GL_ES
precision mediump float;
#endif

//kalu was here!

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


void main( void )
{

	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	

	float c=0.0;
	
	c=1.0 - abs(0.5+0.1*cos(p.x*10.0+time*4.-cos(time*0.4)*5.2) - p.y + (p.x*sin(time)*0.25) + sin(time*((p.y-0.5)))*0.125);
	c=pow(c,21.0*p.x)*(1.0-p.x);
		
	gl_FragColor = vec4(c*p.x,c*p.y,c*sin(time),1.0);
}