#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

vec4 getPixel(vec2 a);
vec2 blockMod(vec2 uv, float modulus);

void main( void ) {
	vec2 uv = gl_FragCoord.xy/resolution.xy;
	vec2 m = uv-mouse;
	float modulus = 32.;
	
	vec2 suv = vec2(0.);
	suv = uv;
	suv.y = gl_FragCoord.y/resolution.x;
	
	
	vec2 block = blockMod(uv, modulus);
 	vec2 subBlock = fract(blockMod(modulus/2.*suv, modulus));
	
	vec4 result = vec4(block, 0., 0.);
	
	if(block.y - block.x == 0.){
		result.xy = subBlock;
	}else{
		result += sin(time)*length(uv - getPixel(subBlock).xy);
	}
	
	gl_FragColor = result;
	//sphinx - not quite right...
}

vec2 blockMod(vec2 uv, float modulus){
	return vec2(uv.x - mod(uv.x, modulus/resolution.x), uv.y - mod(uv.y, modulus/resolution.y));
}

vec4 getPixel(vec2 a){
	return texture2D(backbuffer, a);
}