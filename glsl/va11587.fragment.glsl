#ifdef GL_ES
precision mediump float;
#endif

#define M_PI 3.1415926535897932384626433832795

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void )
{
	vec2 position = ( gl_FragCoord.xy ) / 2.0 - mouse * resolution*0.5;
	float a=cos(position.x)*0.5+0.5;
	float t=time*0.1;
	float b=cos(cos(t)*position.x-sin(t)*position.y)*0.5+0.5;
	float c=b>a ? b: a;
	gl_FragColor = vec4(c, c, c, 1.0 );
}
