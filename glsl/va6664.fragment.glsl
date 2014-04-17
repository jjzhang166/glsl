// schmid

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );// + mouse / 4.0;
	vec2 pc = position + vec2(0.5,0.5);
	float c = pc.x * 0.8 + 4.1;//floor(pc.x * pc.x + pc.y * pc.y);
	float r1 = floor(3.9*sin(c*9.0 +sin(pc.y*20.0+time * 0.01)*0.4+sin(pc.x*20.0+time*0.06)*0.21));
	float r2 = floor(4.7*sin(c*7.0 +sin(pc.y*27.0+time * 0.03)*0.04+sin(pc.x*pc.y*30.0+time*0.09)*0.2));
	float r3 = floor(4.1*sin(c*10.0+sin(pc.y*15.0+time * 0.02)*0.04+sin(pc.y*60.0+time*0.07)*0.2));
	gl_FragColor = vec4( r1+r2+r3, r2*r1-r3, r3-r2, 1.0 ) * mod(pc.y*100.0, 0.3);
}
