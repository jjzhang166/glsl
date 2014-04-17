#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 blockMod(vec2 uv, float modulus);

void main( void ) {

	vec2 uv = gl_FragCoord.xy/resolution.xy;
	vec2 m = uv-mouse;
	
	vec2 block = blockMod(uv, 100.);
	
		
	gl_FragColor = vec4( block, 0., 0. );

}

vec2 blockMod(vec2 uv, float modulus){
	return vec2(uv.x - mod(uv.x, modulus/resolution.x), uv.y - mod(uv.y, modulus/resolution.y));;
}