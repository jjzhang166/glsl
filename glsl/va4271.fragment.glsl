#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float agnesi(float x) {
	return (5.* 5./(x*x +5.*5.));
}


void main( void ) {

	vec2 pos = gl_FragCoord.xy / resolution.xy ;
	float color = (agnesi(distance(pos, mouse))*cos(18.*pos.x + 0.56*time) * cos(31.*pos.x + 0.7*time));
	gl_FragColor = vec4( vec3( sin(3.*color*pos.y + time), (1.-color), 0.8*cos(color) ), 1.0 );

}