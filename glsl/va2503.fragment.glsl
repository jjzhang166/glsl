#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	const float PI = 3.14159265358979323846;

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	float timeScaled = mod(time, 2.0 * PI);
	float sinTime = sin(timeScaled);
	float cosTime = cos(timeScaled);
	float twoTime = time * 2.0;
	float red = ( sin( position.x * cosTime * 5.0 ) + cos( position.y * 6.0 + timeScaled + cosTime )) * ( sinTime * 0.25 + 0.25 ) + 0.5;
	float green = ( sin( cosTime ) * cos( position.y * cosTime )) * 0.2 + 0.5;
	float blue = ( sin( position.x * sinTime * 5.0 + timeScaled ) + cos( position.y * 5.0 * cosTime + timeScaled * cosTime )) * ( cosTime * 0.25 + 0.25 ) + 0.5;
	gl_FragColor = vec4(red, green, blue, 1.0);

}