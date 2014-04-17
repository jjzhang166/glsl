#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(float f){
    	return fract(sin(dot(vec2(f,0.0) ,vec2(12.9898,78.233))) * 43758.5453);
}

	
void main( void )
{

	vec2 x = gl_FragCoord.xy;
	
	if(x.x > time)
		discard;
	
	gl_FragColor = vec4(1.0 ,0.0, 0.0, 0.1);
}