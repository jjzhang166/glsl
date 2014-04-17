// by @Flexi23

#ifdef GL_ES
precision highp float;
#endif
uniform vec2 resolution;
vec2 mul(vec2 a, vec2 b){
   return vec2( a.x*b.x - a.y*b.y, a.x*b.y + a.y*b.x);
}
float square_mask(vec2 domain){
	return (domain.x <= 1. && domain.x >= 0. && domain.y <= 1. && domain.y >= 0.) ? 1. : 0.; 
}

void main( void ) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	gl_FragColor = vec4(0.);

	vec2 c = vec2(0.2475,0.4);
	vec2 z = vec2(1.8,0.);

	float julia = 0.;

	uv -= 0.5;
	uv = mul(uv, z);
	uv = mul(uv, uv) + c;
//
	uv -= 0.5;
	uv = mul(uv, z);
	uv = mul(uv, uv) + c;
//
	uv -= 0.5;
	uv = mul(uv, z);
	uv = mul(uv, uv) + c;
//
	uv -= 0.5;
	uv = mul(uv, z);
	uv = mul(uv, uv) + c;
//
	uv -= 0.5;
	uv = mul(uv, z);
	uv = mul(uv, uv) + c;
//
	uv -= 0.5;
	uv = mul(uv, z);
	uv = mul(uv, uv) + c;
//
	uv -= 0.5;
	uv = mul(uv, z);
	uv = mul(uv, uv) + c;
//
	uv -= 0.5;
	uv = mul(uv, z);
	uv = mul(uv, uv) + c;
	julia += square_mask(uv);
//
	gl_FragColor = vec4(julia);
}