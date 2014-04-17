#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.14159;
const float TWO_PI = 2.0 * PI;
const float a = 0.1;
const float b = 0.15;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	vec2 toCenter = position - vec2(0.5);
	float diff = length( toCenter );
	float angle = acos(dot(toCenter, vec2(0.0, 1.0)) / diff);
	if (toCenter.x > 0.0)
		angle = TWO_PI - angle;
	angle /= TWO_PI;

	float testTheta = log(diff / a) / b;
	testTheta += time;
	testTheta = fract(testTheta / TWO_PI);
	
	float strength = 2.0 * abs( 0.5 - abs(abs(testTheta) - angle));
	vec3 color = vec3(
		sin(position.x * position.x + time),
		sin(position.y - time),
		sin(position.x * time) * cos(position.y * time)
	);
	color *= strength;
	
	gl_FragColor = vec4( color, 1.0 );

}