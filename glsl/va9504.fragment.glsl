#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float polar(vec2 pos)
{
	pos -= 0.5;
	pos *= 2.0;
	
	float theta = atan(pos.y/pos.x);
	
	float t = sin(time) * 0.5 + 0.5;
	
	float c = sin(time * 4.0) * 0.25 + 0.5;	
	c *= t;
	
	float f = cos(6.0 * theta + time*4.0) * 0.25 + 0.25;
	f *= 1.0 - t;
	
	float r = c + f;
	
	float v = r - length(pos);
	
	return v;
}
void main( void ) {
	// r = 2.0*sin(4.0*theta)	
	// r = sqrt(x*x + y*y);
	// theta = atan(y/x);
	// x = r*cos(theta)
	// y = r*sin(theta)
	
	vec2 pos = ( gl_FragCoord.xy / resolution.xy );	
	
	vec4 col = vec4(0.0);
			
	float v = polar(pos);
	v *= 4.0;
	
	float s = clamp(v * 1000.0, 0.0, 1.0);
	
	col.r += sin(v + time) + 0.5;
	col.g += v;
	col.b += sin(v + time * 4.0) + 0.5;
	
	gl_FragColor = col;

}