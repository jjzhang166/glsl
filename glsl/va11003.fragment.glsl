#ifdef GL_ES
precision mediump float;
#endif

//	portation of the effect from www.cake23.de/entertheloop4.html 
//	by @Flexi23

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

vec2 complex_mul(vec2 factorA, vec2 factorB){
   return vec2( factorA.x*factorB.x - factorA.y*factorB.y, factorA.x*factorB.y + factorA.y*factorB.x);
}

vec2 torus_mirror(vec2 uv){
	return vec2(1.)-abs(fract(uv*.5)*2.-1.);
}

float circle(vec2 uv, float scale){
	return clamp( 1. - length((uv-0.5)*scale), 0., 1.);
}

float sigmoid(float x) {
	return 2./(1. + exp2(-x)) - 1.;
}

float smoothcircle(vec2 uv, float radius, float sharpness){
	return 0.5 - sigmoid( ( length( (uv - 0.5)) - radius) * sharpness) * 0.5;
}

/// basically just a lookup from a texture with GL_LINEAR (instead of the active GL_NEAREST method for the backbuffer) resembled in shader code - surely not very efficient, but hey it looks much better and works on Float32 textures too!
vec4 bilinear(sampler2D sampler, vec2 uv, vec2 resolution){
	vec2 pixelsize = 1./resolution;
	vec2 pixel = uv * resolution;
	vec2 d = pixel - floor(pixel) + 0.5;
	pixel = (pixel - d)*pixelsize;
	
	vec2 h = vec2( pixel.x, pixel.x + pixelsize.x);
	if(d.x < 0.5)
		h = vec2( pixel.x, pixel.x - pixelsize.x);
	
	vec2 v = vec2( pixel.y, pixel.y + pixelsize.y);
	if(d.y < 0.5)
		v = vec2( pixel.y, pixel.y - pixelsize.y);
	
	vec4 lowerleft = texture2D(sampler, vec2(h.x, v.x));
	vec4 upperleft = texture2D(sampler, vec2(h.x, v.y));
	vec4 lowerright = texture2D(sampler, vec2(h.y, v.x));
	vec4 upperright = texture2D(sampler, vec2(h.y, v.y));
	
	d = abs(d - 0.5);
	
	return mix( mix( lowerleft, lowerright, d.x), mix( upperleft, upperright, d.x),	d.y);
}
void main( void ) {
	vec2 uv = ( gl_FragCoord.xy / resolution.xy );
	float mouseW = atan(mouse.y - 0.5, mouse.x - 0.5);
	vec2 mousePolar = vec2(sin(mouseW), cos(mouseW));
	vec2 offset = (mouse - 0.5)*4.;

	gl_FragColor = vec4(circle(uv, 4.)* 0.482); // seed

	float filter = smoothcircle(uv, 0.25, 28.);
	gl_FragColor += bilinear(backbuffer, torus_mirror(0.5 + complex_mul(((uv - 0.5)*mix(1.5, 8., filter)), mousePolar) - complex_mul(offset, mousePolar)), resolution)*mix(1., 0.618, filter); // add complex feedback (:
}