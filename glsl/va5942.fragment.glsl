#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;

void main( void ) {
       vec2 res =vec2(500,500);
	vec2 aspect = vec2(1.,resolution.y/resolution.x);
	vec2 uv = 0.5 + ( gl_FragCoord.xy / resolution - 0.5)*aspect;
	gl_FragColor = vec4(length(uv-0.5));
}