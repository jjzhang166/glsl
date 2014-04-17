// fuck that shit.

// Looks oddly like a 3d shape but it isn't really

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

vec2 cmul(const vec2 c1, const vec2 c2)
{
	return vec2(
		c1.x * c2.x - c1.y * c2.y,
		c1.x * c2.y + c1.y * c2.x
	);
}

void main( void ) {
	vec2 p = surfacePosition*(sin(time*0.29)*1.0+3.0) + vec2(0.0, -1.0);
	vec2 z = vec2(sin(time*0.42)*0.5, cos(time*0.333)*0.5);
	float d = 99.0;
	for (int i = 0; i < 10; i++) {
		z =  z.yx * vec2(0.4, -0.5) + sin(time*0.4)*0.05 + 0.5;
		p += z*z;
		z = cmul(z, p) * ( sin(time*0.74) * 0.2 + 1.5); 
		d = min(d, distance(p, z));
	}
	vec3 col = vec3(d * 6.25, d * 2.05, d * 3.0);
	col.r *= mod(gl_FragCoord.y, 2.0) * 0.5;
	gl_FragColor = vec4(col, 1.0);
}