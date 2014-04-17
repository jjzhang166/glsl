#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform sampler2D backbuffer;

vec2 pixelSize = 1./resolution;

/// basically just a lookup from a texture with GL_LINEAR (instead of the active GL_NEAREST method for the backbuffer) resembled in shader code - surely not very efficient, but hey it looks much better and works on Float32 textures too!
vec4 bilinear(sampler2D sampler, vec2 uv){
	vec2 pixelsize = 1./resolution;
	vec2 pixel = uv * resolution;
	vec2 d = pixel - floor(pixel) + 0.5;
	pixel = (pixel - d)*pixelsize;
	
	vec2 h = vec2( pixel.x, pixel.x + pixelsize.x);
	if(d.x <= 0.5)
		h = vec2( pixel.x, pixel.x - pixelsize.x);
	
	vec2 v = vec2( pixel.y, pixel.y + pixelsize.y);
	if(d.y <= 0.5)
		v = vec2( pixel.y, pixel.y - pixelsize.y);
	
	vec4 lowerleft = texture2D(sampler, vec2(h.x, v.x));
	vec4 upperleft = texture2D(sampler, vec2(h.x, v.y));
	vec4 lowerright = texture2D(sampler, vec2(h.y, v.x));
	vec4 upperright = texture2D(sampler, vec2(h.y, v.y));
	
	d = abs(d - 0.5);
	
	return mix( mix( lowerleft, lowerright, d.x), mix( upperleft, upperright, d.x),	d.y);
}
vec4 blurV(vec2 uv){
	float v = pixelSize.y;
	vec4 sum = vec4(0.0);
	sum += bilinear(backbuffer, vec2(uv.x, - 4.0*v + uv.y) ) * 0.05;
	sum += bilinear(backbuffer, vec2(uv.x, - 3.0*v + uv.y) ) * 0.09;
	sum += bilinear(backbuffer, vec2(uv.x, - 2.0*v + uv.y) ) * 0.12;
	sum += bilinear(backbuffer, vec2(uv.x, - 1.0*v + uv.y) ) * 0.15;
	sum += bilinear(backbuffer, vec2(uv.x, + 0.0*v + uv.y) ) * 0.16;
	sum += bilinear(backbuffer, vec2(uv.x, + 1.0*v + uv.y) ) * 0.15;
	sum += bilinear(backbuffer, vec2(uv.x, + 2.0*v + uv.y) ) * 0.12;
	sum += bilinear(backbuffer, vec2(uv.x, + 3.0*v + uv.y) ) * 0.09;
	sum += bilinear(backbuffer, vec2(uv.x, + 4.0*v + uv.y) ) * 0.05;
	sum.xyz = sum.xyz/0.98;
	sum.a = 1.;
	return sum;
}

vec4 blurH(vec2 uv){
	float h = pixelSize.x;
	vec4 sum = vec4(0.0);
	sum += bilinear(backbuffer, vec2(uv.x - 4.0*h, + uv.y) ) * 0.05;
	sum += bilinear(backbuffer, vec2(uv.x - 3.0*h, + uv.y) ) * 0.09;
	sum += bilinear(backbuffer, vec2(uv.x - 2.0*h, + uv.y) ) * 0.12;
	sum += bilinear(backbuffer, vec2(uv.x - 1.0*h, + uv.y) ) * 0.15;
	sum += bilinear(backbuffer, vec2(uv.x + 0.0*h, + uv.y) ) * 0.16;
	sum += bilinear(backbuffer, vec2(uv.x + 1.0*h, + uv.y) ) * 0.15;
	sum += bilinear(backbuffer, vec2(uv.x + 2.0*h, + uv.y) ) * 0.12;
	sum += bilinear(backbuffer, vec2(uv.x + 3.0*h, + uv.y) ) * 0.09;
	sum += bilinear(backbuffer, vec2(uv.x + 4.0*h, + uv.y) ) * 0.05;
	sum.xyz = sum.xyz/0.98;
	sum.a = 1.;
	return sum;
}


void main( void ) {
	vec2 uv = gl_FragCoord.xy*pixelSize + pixelSize*0.5;
	float mouse = clamp(1.- length((uv - mouse)*resolution)/4., 0., 1.);
	gl_FragColor.g = blurH(uv).r;
	gl_FragColor.b = blurV(uv).g;
	vec2 d = pixelSize*2.5;
	vec2 dx;
	dx.x = bilinear(backbuffer, uv-vec2(1.,0.)*d).b - bilinear(backbuffer, uv+vec2(1.,0.)*d).b;
	dx.y = bilinear(backbuffer, uv-vec2(0.,1.)*d).b - bilinear(backbuffer, uv+vec2(0.,1.)*d).b;
	vec2 uvr = uv - dx * pixelSize*4.;

	float r = bilinear(backbuffer,uvr).r;
	r += (r - bilinear(backbuffer,uvr).b)*13./256.;
	r -= 1./256. - mouse*0.5;
	
	gl_FragColor.r = r;
//	gl_FragColor = vec4(  1.0 );

}