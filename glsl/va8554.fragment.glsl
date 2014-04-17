#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI2 6.28318530718

void main( void ) {
	vec2 p = vec2(gl_FragCoord.x/resolution.x * 1.4, gl_FragCoord.y/resolution.y * 2.0 - 1.0);
	mat4 c = mat4(1.0, 1.0, 1.0, 1.0, 0.52, 0.47, 0.87, 1.0, 0.28, 0.22, 0.66, 1.0,	0.01, 0.01, 0.03, 1.0);			
	int i = 0;		
	
	if ( p.y  < sin(sin(p.x)*PI2*1.0+time+PI2/3.0*1.0)*sin(time/2.0+PI2/3.0*1.0)*0.2) ++i;		
	if ( p.y  < sin(sin(p.x)*PI2*1.1+time+PI2/3.0*2.0)*sin(time/2.0+PI2/3.0*2.0)*0.2) ++i;		
	if ( p.y  < sin(sin(p.x)*PI2*1.2+time+PI2/3.0*3.0)*sin(time/2.0+PI2/3.0*3.0)*0.2) ++i;		
	
	if (i==0) gl_FragColor = c[0];
	if (i==1) gl_FragColor = c[1];
	if (i==2) gl_FragColor = c[2];
	if (i==3) gl_FragColor = c[3];
		
	gl_FragColor *= mod(gl_FragCoord.y, 2.0);
}