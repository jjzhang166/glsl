#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	p -= vec2(0.5);
	p.x *= resolution.x / resolution.y;

	float color = p.x;

	float x = 2.0+fract(length(p)*2.0)*6.0;
	
	float r = -(clamp(x-3.0,0.0,1.0)+clamp(-x+1.0,0.0,1.0))+1.0 -(clamp(x-9.0,0.0,1.0)+clamp(-x+7.0,0.0,1.0))+1.0;
	float g = -(clamp(x-5.0,0.0,4.0)+clamp(-x+3.0,0.0,1.0))+1.0;
	float b = -(clamp(x-7.0,0.0,1.0)+clamp(-x+5.0,0.0,1.0))+1.0;
	
	
	gl_FragColor = vec4( vec3( r, g , b), 1.0 );

}