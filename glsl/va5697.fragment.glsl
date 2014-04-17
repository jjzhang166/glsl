#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;

float r(vec2 seed){return abs(fract(sin(dot(seed.xy ,vec2(12.9898,78.233))) * 43758.5453));}

// Oak Wood Grain

void main( void ) {
	vec2 f = gl_FragCoord.xy/resolution;
	float c = r(f.xy)*r(f.yx)*r(f.xx)*r(f.xx);
	gl_FragColor = vec4(c*0.9,c*0.3,c*0.1,1.0) * smoothstep(f.x,1.0,0.9);
}