// fast... for slow GPUs


#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void )
{
	
	float temp = mod(((gl_FragCoord.y-resolution.y/2.)/(gl_FragCoord.x-resolution.x/2.)+time/10.)/.4,1.);
	gl_FragColor = vec4(temp, temp, temp, 1.0);
}

