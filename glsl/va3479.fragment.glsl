#ifdef GL_ES
precision mediump float;
#endif

uniform float time;

void main( void ) {
	float p = gl_FragCoord.x*0.0005;
	vec2 position = (gl_FragCoord.xy / (5.+sin(time*0.7823)*3.5)) * mat2(sin(p+time*1.412), cos(p+time*0.82024), cos(p), -sin(time-p));
	gl_FragColor = vec4(  min(1.0,(0.5 + pow(fract(time*11.)*(sin(time*0.4)+1.)*0.7,10.))) * vec3( cos(position.x), cos(position.y), cos((position.x-position.y+time*0.1))), 1.0 );
}
