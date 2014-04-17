#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 uv =(gl_FragCoord.xy/resolution.xy);
	float col=0.0;
	float ball;
	
	float num = 4.0;

	ball += pow(
			1.0/100.0/abs(mod(uv.x - time / 4.0, 1.0 / num) - 1.0 / num)
		,1.2);
	
	col =ball;
	gl_FragColor=vec4(col*0.3,col*0.4,col*0.2,1.0);
}