#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

#define PI 3.14159

float sphere(vec3 p, vec3 pObj, float radius) {
	return (length(p-pObj) - radius) * 1.0/radius; //return is -1 at pObj and 0 when on radius
}
float cube(vec3 p, vec3 pObj, float halfSize) {
	vec3 d = abs(p-pObj) / halfSize; //[0,1]
	d = -1.0+d; //neg when inside
	float dborder = max(max(d.x,d.y),d.z);
	return dborder;
}
float acosAngle(vec2 v) {
	float x = v.x;
	float y = v.y;
	if (x == 0.0 && y == 0.0)
		return 0.0;
	float a = acos(x / sqrt(x * x + y * y)); 
	if (y < 0.0)
		a = 2.0 * PI - a;
	return 2.0 * PI - a;
}
void main( void ) {

	vec2 p = surfacePosition*8.0;
	p /= pow(2.0,(sin(time*0.1)/2.0+0.5)*20.0);
	vec2 z = p;
	float d;
	for (int i=2; i<25; i++) {
		z = fract(z)-0.5;
		z *= 2.0;
		float dd = -sphere(vec3(z,0), vec3(0), 0.5);
		if (dd > 0.0) {
			d += dd;
			break;
		}
	}
	vec3 color;
	color += d;
	gl_FragColor.xyz = color;

}