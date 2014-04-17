#ifdef GL_ES
precision mediump float;
#endif

uniform float time;

void main( void )
{
	float costime=cos(time*5.0);
	float ratio=1.0/10.0;
	float val=costime+cos(gl_FragCoord.x*ratio)+cos(gl_FragCoord.y*ratio);
        vec4 col=vec4(1.0,0.2,0.2,1.0);	
	
	gl_FragColor = col*val;
}
