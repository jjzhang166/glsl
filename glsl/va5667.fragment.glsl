#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//this is some crazy fractal shit!
//MrOMGWTF
void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy  * 2.0) - 1.0;
	float color = 0.0;
	float x,y,m,cx,cy;
	x = p.x;
	y = p.y;
	cx = -(sin(time * 0.5) * 0.5 + 0.5);
	cy = -(cos(time * 0.5) * 0.5 + 0.5);
	for(int i = 0; i < 7; i++)
	{
		x = abs(x);
		y = abs(y);
		m = x * x + y * y;
		x = x / m * 0.7 + cx;
		y = y / m * 1.3 + cy;
	}
	gl_FragColor = vec4( vec3( m ), 1.0 );

}