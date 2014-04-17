// Mash-up from 68/1 and 277/10 - watch it with 1x or 0.5x sampling

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

void main( void ) {
	gl_FragColor = vec4(1.); // init white
	float bit = 1./256.;
	vec2 pixel = 1./resolution;
	vec2 uv = gl_FragCoord.xy*pixel;

	bool mousePixel = uv.x + pixel.x > mouse.x && uv.x < mouse.x && uv.y + pixel.y > mouse.y && uv.y < mouse.y;
	float seed = mousePixel ? 1. : 0.;

	vec2 borderSize = pixel*4.;
	bool borderMask = uv.x < borderSize.x || uv.x > 1.-borderSize.x || uv.y < borderSize.y || uv.y > 1.- borderSize.y ;
	
	float rnd1 = mod(fract(sin(dot(uv + time*0., vec2(14.9898,78.233))) * 43758.5453), 1.0);
	float rnd2 = mod(fract(sin(dot(uv+vec2(rnd1), vec2(14.9898,78.233))) * 43758.5453), 1.0);
	float rnd3 = mod(fract(sin(dot(uv+vec2(rnd2), vec2(14.9898,78.233))) * 43758.5453), 1.0);
	float rnd4 = mod(fract(sin(dot(uv+vec2(rnd3), vec2(14.9898,78.233))) * 43758.5453), 1.0);

	vec2 cc = vec2(-0.25, 0.0) + (mouse.yx-0.5)*vec2(0.2,-0.55);
	vec2 tuning =  vec2(1.8) - (mouse.y-0.5)*0.3;
	
	vec2 complexSquaredPlusC; // One steps towards the Julia Attractor
	vec2 uv2 =  (uv - vec2(0.5))*tuning;
	complexSquaredPlusC.x = (uv2.x * uv2.x - uv2.y * uv2.y + cc.x + 0.5);
	complexSquaredPlusC.y = (2. * uv2.x * uv2.y + cc.y + 0.5);

	uv = complexSquaredPlusC;

	// http://en.wikipedia.org/wiki/Von_Neumann_neighborhood

	vec4 c = texture2D(backbuffer, uv);
	vec4 n = texture2D(backbuffer, uv + vec2(0.,-1.)*pixel);
	vec4 s = texture2D(backbuffer, uv + vec2(0.,1.)*pixel);
	vec4 e = texture2D(backbuffer, uv + vec2(-1.,0.)*pixel);
	vec4 w = texture2D(backbuffer, uv + vec2(1.,0.)*pixel);

	vec4 maxvn = max(c,max(max(n,s),max(e,w))); // maximum in the von Neumann neighborhood
	vec4 minvn = min(c,min(min(n,s),min(e,w)));

	vec4 old = texture2D(backbuffer, complexSquaredPlusC);
	if(is_onscreen(complexSquaredPlusC)){
		gl_FragColor = old;//min(vec4(old), minvn);
		gl_FragColor += (vec4(rnd4,rnd3,rnd2,rnd1)-0.5)*8.*bit - 0.25*bit; // error diffusion
		gl_FragColor.xyz -= 12.*bit*(gl_FragColor.yzx-gl_FragColor.zxy); // http://en.wikipedia.org/wiki/Belousov-Zhabotinsky_reaction
	}else{
		// return border color
		gl_FragColor = vec4(1.);
	}

//	gl_FragColor = vec4(1.);
}