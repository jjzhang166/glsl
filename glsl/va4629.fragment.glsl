#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float noise(vec2 p) {
	p=(p);
	return fract(sin(p.x*45.11+p.y*97.23)*878.73+733.17)*2.0-1.0;
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	float x = noise(vec2(position.x*0.000003,5));
	float z = noise(vec2(position.y*0.000001,0.5));
	
	float color = abs(fract((x+position.x+z*noise(vec2(x,z))))-.5)*2.;
	
	gl_FragColor = vec4( pow(vec3(color), vec3(0.9, 1.1, 0.9)), 1.0 );
}