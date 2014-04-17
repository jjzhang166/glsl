#ifdef GL_ES
precision mediump float;
#endif
// maybe bkg for one of my websites
// sometimes some rows are blinking, dont know why, it looks like something is wrong with time value bcause they stop after a while :) :)
// noise taken from some other shader
// zzz zbigniew.polito@gmail.com
uniform float time;
uniform vec2 resolution;

float hash( float n ) {
	return fract(sin(n)*43758.5453);
}

float noise2( in vec2 x ) {
	vec2 p = floor(x);
	vec2 f = fract(x);
    	f = f*f*(3.0-2.0*f);
    	float n = p.x + p.y*57.0;
    	float res = mix(mix(hash(n+0.0), hash(n+1.0),f.x), mix(hash(n+57.0), hash(n+58.0),f.x),f.y);
    	return res;
}

void main( void ) {

	vec3 colorOut;
	float x = gl_FragCoord.x/((resolution.x/150.0));
	float y = gl_FragCoord.y/((resolution.x/150.0));
	
	vec2 position = vec2(floor(x),floor(y));
	{
		colorOut = vec3((noise2(position))-(1.3-(cos(noise2((position)+time/6.0)+sin(noise2((position)+time/6.0))))))/2.0;
	}
	gl_FragColor = vec4(colorOut, 1.0);

}