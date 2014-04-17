// interference pattern with mouse control

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = gl_FragCoord.xy/resolution.y-vec2((resolution.x/resolution.y)/2.0,0.5);
	float value = sin(1.0-distance(position,vec2(0.5,0.23))*64.0+time*8.0)*0.5+0.5;
	position.x+=(-mouse.x+0.5)*1.85;
	position.y+=(-mouse.y+0.5)*1.0;
	value+=sin(1.0-distance(position,0.1 * vec2(sin(gl_FragCoord.x / resolution.x - time * 0.2) * 5.3,cos(gl_FragCoord.y / resolution.y + time * 0.3) * 5.3))*64.0+time*8.0)*0.5+0.5;
	value = pow(value, 50.);
	gl_FragColor = vec4(value,value,value, 1.0 );

}