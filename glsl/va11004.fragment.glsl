// @Flexi23

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

bool is_onscreen(vec2 uv){
	return (uv.x < 1.) && (uv.x > 0.) && (uv.y < 1.) && (uv.y > 0.);
}

/// basically just a lookup from a texture with GL_LINEAR (instead of the active GL_NEAREST method for the backbuffer) resembled in shader code - surely not very efficient, but hey it looks much better and works on Float32 textures too!
vec4 bilinear(sampler2D sampler, vec2 uv){
	vec2 pixelsize = 1./resolution;
	vec2 pixel = uv * resolution;
	vec2 d = pixel - floor(pixel) + 0.5;
	pixel = (pixel - d + 0.)*pixelsize;
	
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

	vec2 position = gl_FragCoord.xy / resolution.xy;
	float aspect = resolution.x/resolution.y;

	// noise copied from http://glsl.heroku.com/37/3

       float rand = mod(fract(sin(dot(position + time, vec2(12.9898,78.233))) * 43758.5453), 1.0);

	// stepping into it

	vec2 rnd;
       	rnd.x = mod(fract(sin(dot(position, vec2(12.9898,78.233+rand))) * 43758.5453), 1.0);
       	rnd.y = mod(fract(sin(dot(position, vec2(12.9898,78.233+rnd.x))) * 43758.5453), 1.0);

	// Julia fractal in .y

	vec2 c = vec2(-0.25, 0.0) + (mouse.yx-0.5)*vec2(0.2,-0.55);
	vec2 tuning =  vec2(1.8) - (mouse.y-0.5)*0.3;
	/*
	vec2 c = vec2(-0.18, -0.18) + (mouse.yx-0.5)*vec2(0.02,-0.055);
	vec2 tuning =  vec2(1.7) - (mouse.y-0.5)*0.03;
	*/
	vec2 complexSquaredPlusC; // One steps towards the Julia Attractor
	vec2 uv = rnd*0. + (position - vec2(0.5))*tuning;
	complexSquaredPlusC.x = (uv.x * uv.x - uv.y * uv.y + c.x + 0.5);
	complexSquaredPlusC.y = (2. * uv.x * uv.y + c.y + 0.5);
	
	float old = bilinear(backbuffer, complexSquaredPlusC).y;
	if(is_onscreen(complexSquaredPlusC)){
		gl_FragColor.y = old + 0.004;
	}else{
		// return border color
		gl_FragColor.y = 0.;
	}

	// using the gradients from .y as displacement vector for the spotlight in .z
	vec2 pixelSize = 0.75/resolution;
	float dx = bilinear(backbuffer, position + vec2(1.,0.)*pixelSize).y - bilinear(backbuffer, position - vec2(1.,0.)*pixelSize).y;
	float dy = bilinear(backbuffer, position + vec2(0.,1.)*pixelSize).y - bilinear(backbuffer, position - vec2(0.,1.)*pixelSize).y;
	float d = length(( mouse - position + vec2(dx,dy)*8.) * vec2( aspect, 1.0 ));
	float light = clamp( 1.-d,0.,1.);
	gl_FragColor.z = pow(light,4.);
	gl_FragColor.a = 1.;

	// using the diff in .y as input in .x
	gl_FragColor.x = abs(old-texture2D(backbuffer, position).y); // diffs are magical
	vec2 zoomin = mouse + (position-mouse)*0.99 + (rnd-0.5)*0.0025; // yay, error diffusion dither
	gl_FragColor.x = bilinear(backbuffer, zoomin).x - 0.025 + gl_FragColor.x;
}