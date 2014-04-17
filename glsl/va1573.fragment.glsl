#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform sampler2D backbuffer;

vec2 pixelSize = 1./resolution;

// This would look much better if the backbuffer texture MIN/MAG_FILTER was LINEAR

vec4 blurV(vec2 uv){
	float v = pixelSize.y;
	vec4 sum = vec4(0.0);
	sum += texture2D(backbuffer, vec2(uv.x, - 4.0*v + uv.y) ) * 0.05;
	sum += texture2D(backbuffer, vec2(uv.x, - 3.0*v + uv.y) ) * 0.09;
	sum += texture2D(backbuffer, vec2(uv.x, - 2.0*v + uv.y) ) * 0.12;
	sum += texture2D(backbuffer, vec2(uv.x, - 1.0*v + uv.y) ) * 0.15;
	sum += texture2D(backbuffer, vec2(uv.x, + 0.0*v + uv.y) ) * 0.16;
	sum += texture2D(backbuffer, vec2(uv.x, + 1.0*v + uv.y) ) * 0.15;
	sum += texture2D(backbuffer, vec2(uv.x, + 2.0*v + uv.y) ) * 0.12;
	sum += texture2D(backbuffer, vec2(uv.x, + 3.0*v + uv.y) ) * 0.09;
	sum += texture2D(backbuffer, vec2(uv.x, + 4.0*v + uv.y) ) * 0.05;
	sum.xyz = sum.xyz/0.98;
	sum.a = 1.;
	return sum;
}

vec4 blurH(vec2 uv){
	float h = pixelSize.x;
	vec4 sum = vec4(0.0);
	sum += texture2D(backbuffer, vec2(uv.x - 4.0*h, + uv.y) ) * 0.05;
	sum += texture2D(backbuffer, vec2(uv.x - 3.0*h, + uv.y) ) * 0.09;
	sum += texture2D(backbuffer, vec2(uv.x - 2.0*h, + uv.y) ) * 0.12;
	sum += texture2D(backbuffer, vec2(uv.x - 1.0*h, + uv.y) ) * 0.15;
	sum += texture2D(backbuffer, vec2(uv.x + 0.0*h, + uv.y) ) * 0.16;
	sum += texture2D(backbuffer, vec2(uv.x + 1.0*h, + uv.y) ) * 0.15;
	sum += texture2D(backbuffer, vec2(uv.x + 2.0*h, + uv.y) ) * 0.12;
	sum += texture2D(backbuffer, vec2(uv.x + 3.0*h, + uv.y) ) * 0.09;
	sum += texture2D(backbuffer, vec2(uv.x + 4.0*h, + uv.y) ) * 0.05;
	sum.xyz = sum.xyz/0.98;
	sum.a = 1.;
	return sum;
}

void main( void ) {
	vec2 uv = gl_FragCoord.xy*pixelSize;
	float mouse = clamp(1.- length((uv - mouse)*resolution)/4., 0., 1.);
	gl_FragColor.g = blurH(uv).r;
	gl_FragColor.b = blurV(uv).g;
	vec2 d = pixelSize*2.;
	vec2 dx;
	dx.x = texture2D(backbuffer, uv-vec2(1.,0.)*d).b - texture2D(backbuffer, uv+vec2(1.,0.)*d).b;
	dx.y = texture2D(backbuffer, uv-vec2(0.,1.)*d).b - texture2D(backbuffer, uv+vec2(0.,1.)*d).b;
	vec2 uvr = uv - dx * pixelSize*2.25;

	float r = texture2D(backbuffer,uvr).r;
	r += (r - texture2D(backbuffer,uvr).b)*4.5/256.;
	r -= 1.33/256. - mouse*0.5;
	
	gl_FragColor.r = r;
//	gl_FragColor = vec4(  1.0 );

}