#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float circle(vec2 uv, vec2 pos, float d){
	return ( length(uv - pos) < d ) ? 1. : 0.;
}

void main( void ) {
	
	vec2 aspect = vec2(resolution.x/resolution.y,1.);

	vec2 uv = 1.0 + ( gl_FragCoord.x / resolution.x -0.5 )*mouse*aspect;
	
	vec2 mouse = 0.5 + (mouse-0.5)*aspect;

	vec2 pos1 = vec2( 0.35, 0.75);
	vec2 pos2 = vec2( time, 0.75);
	
	float w1 = atan(mouse.x-pos1.x, mouse.y-pos1.y);
	vec2 d1 = vec2(sin(w1), sin(w1 + asin(1.)));

	float w2 = atan(mouse.x-pos2.x, mouse.y-pos2.y);
	vec2 d2 = vec2(sin(w2), sin(w2 + asin(1.)));

	
	float layer1 = circle(uv, pos1, 0.1) - circle(uv, pos1, 0.09) + circle(uv, pos2, 0.1) - circle(uv, pos2, 0.09);
	layer1 += circle(uv, pos1 + d1*0.07, 0.015);
	layer1 += circle(uv, pos2 + d2*0.07, 0.015);
	
	gl_FragColor = vec4(layer1);

	
	gl_FragColor.a = 1.0;

}