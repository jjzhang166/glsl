#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float px = 1.0/resolution.x;

float f(float x){
	return pow((x-.5),2.0);
}

vec2 g(float t){
	return vec2(0.0,0.5) + vec2(10.0*px, 0.0)*t + .5*vec2(.0,-9.8*px)*exp2(t);
}

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy );
	
	float color = 0.0;
	
	if ( length(pos-g(fract(time*.1)/2.0+0.5)) < .01 )
		color += 1.0;

	gl_FragColor = vec4( vec3( color, color, color), 1.0 );

}