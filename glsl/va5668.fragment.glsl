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
		m = atan(atan(x*x)*x+atan(y*y)*y);
		x = x / m * 0.7 + cx;
		y = y / m * 1.3 + cy;
	}
	vec3 col=vec3(m,m*0.25, m*0.125 );
	col=(col-normalize(col)*0.65)*2.0;
	gl_FragColor = vec4( col, 1.0 );

}