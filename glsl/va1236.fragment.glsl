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

	vec2 position = ( gl_FragCoord.xy / vec2(resolution.y, resolution.y) ) + mouse * 12.0 / 10.0;
	position.x = position.x/.6-1.2;
	position.y = position.y/.6-.6;
	
	float r = length(position);
	float t = atan(position.y, position.x);
	
	float color = 1.0/((r*2.0) - (1.0+sin(t))*(1.0+0.9*cos(8.0*t))*(1.0+0.1*cos(24.0*t))*(0.5+0.05*cos(140.0*t)));

	gl_FragColor = vec4( 0.0 + color_sin(time+log(color))*.05, (1.0-color)*.33, color_cos(time+log(color))*.05, 1.0 );

}
