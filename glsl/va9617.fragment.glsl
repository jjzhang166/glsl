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

vec3 rgbFromHue(in float h) {
	h = fract(h)*6.0;
	
	float c0 = clamp(h,0.0,1.0);
	float c1 = clamp(h-1.0,0.0,1.0);
	float c2 = clamp(h-2.0,0.0,1.0);
	float c3 = clamp(h-3.0,0.0,1.0);
	float c4 = clamp(h-4.0,0.0,1.0);
	float c5 = clamp(h-5.0,0.0,1.0);
	
	float r = (1.0 - c1) + c4;
	float g = c0 - c3;
	float b = c2 - c5;
	
	return vec3(r,g,b);
}

float distf(vec2 p) {
	//p = p*16.0;//p * 4.0 + vec2(0.0, -1.0);
	vec2 z = vec2(0.5);//mouse;//vec2(0.7, -0.7);
	float d = 999.0;
	for (int i = 0; i < 4; i++) {
		z =  z.yx * vec2(1.0, -1.0) * cmul(p, p) + 1.0;
		//p += z*z;
		//p = abs(p)/dot(z,z);
		z = cmul(z, z);
		d = min(d, length(p/z));
	}
	return d-1.0;	
}

vec3 normal(vec2 p)
{
	vec3 off = vec3(-1.0, 0.0, 1.0);
	vec2 size = vec2(0.0, 2.0);
	float wave = distf(p);
    	float s01 = distf(p+off.xy);
    	float s21 = distf(p+off.zy);
    	float s10 = distf(p+off.yx);
    	float s12 = distf(p+off.yz);
	vec3 va = normalize(vec3(size.xy,s21-s01));
	vec3 vb = normalize(vec3(size.yx,s12-s10));
	vec4 bump = vec4( cross(va,vb), wave );
	return bump.xyz;
}
void main( void ) {
	gl_FragColor = vec4(vec3(dot(vec3(1.0), normal(surfacePosition*6.0)+0.5)), 1.0)*0.5;
	//gl_FragColor = vec4(rgbFromHue(log(abs(distf(surfacePosition*6.0)))*0.1+0.6),1.0);
}