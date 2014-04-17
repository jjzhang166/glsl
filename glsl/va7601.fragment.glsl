#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// messing around

float PI = 3.14159265;
float PI2 = PI * 2.;

void main()
{
	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float r = (sin((position.x - time / 20. + position.x * sin(time / 4.)) * 10. * PI2));
	r += (cos((position.y + time / 20. + position.x * cos(time / 4.)) * 10. * PI2));
	r = r > sin(time) ? 0. : 1.;

	float g = (sin((position.x - time / 10. + position.x * sin(time / 4.)) * 10. * PI2));
	g += (cos((position.y + time / 10. + position.x * cos(time / 4.)) * 10. * PI2));
	g = g > sin(time) ? 0. : 1.;

	float b = (sin((position.x - time / 5. + position.x * sin(time / 4.)) * 10. * PI2));
	b += (cos((position.y + time / 5. + position.x * cos(time / 4.)) * 10. * PI2));
	b = b > sin(time) ? 0. : 1.;
	
	r = (r + sin(time)) / 2.;
	g = (g + sin(time + PI)) / 2.;
	b = (b + sin(time + PI * 1.5)) / 2.;
	
	gl_FragColor = vec4( r, g, b, 1.0 );

}