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
	vec2 pixel = uv * resolution + 0.5;
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
	
	vec2 uv = gl_FragCoord.xy*pixelSize;
	
	// noise copied from http://glsl.heroku.com/37/3
       float rand = mod(fract(sin(dot(uv + time, vec2(12.9898,78.233))) * 43758.5453), 1.0);

	// stepping into it
	vec2 rnd;
       	rnd.x = mod(fract(sin(dot(uv, vec2(12.9898,78.233+rand))) * 43758.5453), 1.0);
       	rnd.y = mod(fract(sin(dot(uv, vec2(12.9898,78.233+rnd.x))) * 43758.5453), 1.0);
	
  // warp from http://webglplayground.net/?gallery=lotka-volterra
	
  // 2d differential equation known from predator-prey cycles
  // http://en.wikipedia.org/wiki/Lotka%E2%80%93Volterra_equation
  // http://www.wolframalpha.com/input/?i=lotka-volterra
  
  float a = 3.; // prey population growth
  float b = 1.; // see the upepr two links
  float c = 1.;
  float d = 4.;
    
  vec2 scale = vec2(10.,10.);
  float v = 0.7*sin(time*0.1);
  
  vec2 uvs = uv*scale;
  
  float dx = a*uvs.x - b*uvs.x*uvs.y;
  float dy = c*uvs.x*uvs.y - d*uvs.y;
  
	uv = uv + vec2(dx, dy)*v*pixelSize + (rnd-0.5)*pixelSize*0.0;

	vec2 dd = pixelSize*1.;
	dx = bilinear(backbuffer, uv-vec2(1.,0.)*dd).r - bilinear(backbuffer, uv+vec2(1.,0.)*dd).r;
	dy = bilinear(backbuffer, uv-vec2(0.,1.)*dd).r - bilinear(backbuffer, uv+vec2(0.,1.)*dd).r;
	vec2 uvr = uv - vec2(dx, dy) * pixelSize*0.5;
	
	float mouse = clamp(1.- length((uv - mouse)*resolution)/32., 0., 1.);
	gl_FragColor.g = blurH(uv).b;
	gl_FragColor.r = blurV(uv).g;
	float r = bilinear(backbuffer,uvr).b;
	r += (r - bilinear(backbuffer,uvr).r)*16./256.;
	r += -1./256. + mouse*0.5;
	r += (rand-0.5)/128.;
	
	gl_FragColor.b = r;
//	gl_FragColor = vec4(  1.0 );

}