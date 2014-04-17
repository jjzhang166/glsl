#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;

float r(vec2 seed){return abs(fract(sin(dot(seed.xy ,vec2(12.9898,78.233))) * 43758.5453));}

// Denim Cloth

void main( void ) {
	vec2 f = gl_FragCoord.xy/resolution;
	float c = r(f.xy)*r(f.yx)*r(f.xx)*r(f.xx)*r(f.yy);
	gl_FragColor = vec4(c*20.0,c*40.0,c*90.0,1.0) * smoothstep(f.x,1.0,0.9) * sin(gl_FragCoord.x) * sin(gl_FragCoord.y);
}