// cannabola by svarog
#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float color_sin(float x) {
    return (0.5+sin(x)/2.);
}
float color_cos(float x) {
    return (0.5+cos(x)/2.);
}

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / vec2(resolution.y, resolution.y) );
	pos.x = pos.x/.9-0.9;
	pos.y = pos.y/.6-0.4;
	
	float r = length(pos);
	float t = atan(pos.y, pos.x);
	
	float color = 1.0/((r*2.0) - (1.0+sin(t))*(1.0+0.9*cos(32.0*t))*(1.0+0.01*cos(2.0*t))*(0.5+0.05*cos(4.0*t)));

	gl_FragColor = vec4( 0.05, (1.0-color)*.63, .05, 1.0 );

}
