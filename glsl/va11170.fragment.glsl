//mandelbrot fractal with orbit trap
//hide code and use left mouse button to move and right mouse button to zooom //works with varying vec2 surfacePosition
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;
varying vec2 surfacePosition;

//distance functions return negative when inside and positive when outside of object

float sphere(vec3 p, vec3 pObj, float radius) {
	return (length(p-pObj) - radius) * 1.0/radius; //return is -1 at pObj and 0 when on radius
}
float cube(vec3 p, vec3 pObj, float halfSize) {
	vec3 d = abs(p-pObj) / halfSize; //[0,1]
	d = -1.0+d; //neg when inside
	float dborder = max(max(d.x,d.y),d.z);
	return dborder;
}
float speed = time*0.1;
float speedAlongRadius = sin(speed*2.0);
float orbitTrap(vec3 p) {
	float d = 1e10;
	d = min(d, sphere(p,vec3(cos(speed)*speedAlongRadius,sin(speed)*speedAlongRadius,0),0.25));
	d = min(d, cube(p,vec3(-0.25-sin(speed)*3.0,0,0.0),0.25));
	return -d;
}
vec4 bb(vec2 uv) {
	return texture2D(backbuffer,uv);
}
void main( void ) {
	vec2 pt = gl_FragCoord.xy/resolution.xy; //point for textures range [0,1]
	vec2 p = surfacePosition*2.0; //range [-2,2] for mandelbrot
	vec3 c = vec3(p,0);
	vec3 color;
	vec3 z;
	vec3 zcol;
	for (int i=0; i<100; i++) {
		z = vec3(z.x*z.x-z.y*z.y, z.x*z.y*2.0, 0)+c;
		float spr = orbitTrap(z);
		if (spr >= 0.0) {
			//if (sin(time*10.0)<0.0)
				zcol = max(zcol, vec3(spr));
			//else
			//	zcol = vec3(spr);
		}
		//if (spr >= 0.0) break; //stop when stepping on orbit trap
		float d = dot(z,z);
		if (d > 4.0) break; //stop when limes goes towards infinity
	}
	//color = z;
	color = zcol;
	//color.x = orbitTrap(z,vec3(0),0.1);
	gl_FragColor.xyz = color;
	//gl_FragColor.x += bb(pt).x-0.5;
	//gl_FragColor.xyz = vec3(orbitTrap(vec3(p,0))); //Test
}