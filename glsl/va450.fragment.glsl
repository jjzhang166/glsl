#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform sampler2D backbuffer;

void main( void ) {
	gl_FragColor = vec4(0.); // init black

	vec2 pixel = 1./resolution;
	vec2 uv = gl_FragCoord.xy*pixel;

	bool mousePixel = uv.x + pixel.x > mouse.x && uv.x < mouse.x && uv.y + pixel.y > mouse.y && uv.y < mouse.y;
	float seed = mousePixel ? 1. : 0.;

	vec2 borderSize = pixel*4.;
	bool borderMask = uv.x < borderSize.x || uv.x > 1.-borderSize.x || uv.y < borderSize.y || uv.y > 1.- borderSize.y ;
	
	float rnd1 = mod(fract(sin(dot(uv + time, vec2(14.9898,78.233))) * 43758.5453), 1.0);
	float rnd2 = mod(fract(sin(dot(uv+vec2(rnd1), vec2(14.9898,78.233))) * 43758.5453), 1.0);
	float rnd3 = mod(fract(sin(dot(uv+vec2(rnd2), vec2(14.9898,78.233))) * 43758.5453), 1.0);
	float rnd4 = mod(fract(sin(dot(uv+vec2(rnd3), vec2(14.9898,78.233))) * 43758.5453), 1.0);

	gl_FragColor = vec4(0.);

	vec2 rnd = pixel*(vec2(rnd3, rnd4)-0.5)*1.4; // jitter code copied from http://glsl.heroku.com/91/0

	// http://en.wikipedia.org/wiki/Von_Neumann_neighborhood

	vec4 c = texture2D(backbuffer, uv + rnd);
	vec4 n = texture2D(backbuffer, uv + rnd + vec2(0.,-1.)*pixel);
	vec4 s = texture2D(backbuffer, uv + rnd + vec2(0.,1.)*pixel);
	vec4 e = texture2D(backbuffer, uv + rnd + vec2(-1.,0.)*pixel);
	vec4 w = texture2D(backbuffer, uv + rnd + vec2(1.,0.)*pixel);

	vec4 maxvn = max(c,max(max(n,s),max(e,w))); // maximum in the von Neumann neighborhood

	gl_FragColor = max(vec4(seed), maxvn);
	gl_FragColor += (vec4(rnd4,rnd3,rnd2,rnd1)-0.5)*0.0205 - 0.017; // error diffusion
	gl_FragColor.xyz += 0.1126*(gl_FragColor.yzx-gl_FragColor.zxy); // http://en.wikipedia.org/wiki/Belousov-Zhabotinsky_reaction
//	gl_FragColor = vec4(0.);
}