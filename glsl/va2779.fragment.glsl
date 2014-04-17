//  Quick mod by @dennishjorth

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = gl_FragCoord.xy/resolution.y-vec2((resolution.x/resolution.y)/2.0,0.5);
	position.x+=0.4*sin(time*0.5);
	position.y+=0.4*cos(time*0.4);
	float value = sin(1.0-distance(position,vec2(0,0))*32.0+time*4.0)*0.25+0.25;
	position.x+=0.4*sin(time*0.5);
	position.y+=0.4*cos(time*0.3);
	value+=sin(1.0-distance(position,vec2(0,0))*32.0+time*4.0)*0.25+0.25;
	position.x+=0.4*cos(time*0.5);
	position.y+=0.4*sin(time*0.4);
	value+=sin(1.0-distance(position,vec2(0,0))*32.0+time*4.0)*0.25+0.25;
	position.x+=0.4*cos(time*0.3);
	position.y+=0.4*sin(time*0.5);
	value+=sin(1.0-distance(position,vec2(0,0))*32.0+time*4.0)*0.25+0.25;
	gl_FragColor = vec4(value*0.3,value*0.6,value*1.2, 1.0 );

}