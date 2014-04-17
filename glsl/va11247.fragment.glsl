#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 mult(vec2 a, vec2 b) { // complex prod a*b
	return vec2(a.x*b.x-a.y*b.y, a.x*b.y+a.y*b.x);
}

vec2 div(vec2 a, vec2 b) { //complex div a/b
	return 1./(b.x*b.x+b.y*b.y)*mult(a,vec2(b.x,-b.y));
}


vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

vec2 fun(vec2 z) {
	vec2 z0 = z;
	z = vec2(0.);
	for(int i=0; i<13; i++) {
		z = mult(z,z) + z0;
		if(length(z)>10000.) return vec2(0.1,0.1);
	}
	return z;
}

vec4 complexcolor(vec2 z) {
	float a = atan(z.y,z.x)/2./3.141;
	float r = length(z);
	return vec4( hsv2rgb(vec3(a,1.0,0.8+.2*mod(log(r),1.))), 1.0 );
}

void main( void ) {
	float A = mouse.y*3.;
	vec2 uv = ( gl_FragCoord.xy / resolution.xy );
	float ratio = resolution.y/resolution.x;
	vec2 z = uv -vec2(0.5,0.5);
	z.y *= ratio;
	z *= A;
	z += vec2(3.*(mouse.x-0.5),0);
	
	
	
	
	gl_FragColor = complexcolor(fun(z));
	//gl_FragColor = vec4( hsv2rgb(vec3(time*0.1,uv.x,uv.y)), 1.0 );

}