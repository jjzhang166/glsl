#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( (gl_FragCoord.xy-resolution.xy/3.0) / resolution.x ) + mouse / 4.0;

	float x = 0.0, y = 0.0, itf = 0.0;
	for (int it=0; it<50; it++)
	{
		if (x*x + y*y > 4.0) break;
		float xt = x*x - y*y + position.y;
		y = 2.0*x*y + position.x;
		x = xt;
		itf += 1.0;
	}
	
	float t = sin(11.0*0.25+itf/50.0*3.141592)*0.5+0.5;
	
	float t2 = sin(cos(position.x*35.13+position.y*12.0)*cos(position.y*10.23+position.x*5.0)*5.0*t+time) * 0.5 + 0.5;
	
	gl_FragColor.b = t;
	
	
	gl_FragColor.r = 1.0 - t * t2;
	gl_FragColor.g = 1.0 - t * (1.0-t2);
}