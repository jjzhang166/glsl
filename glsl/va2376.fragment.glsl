// interference pattern with mouse control
// with highlighting cancellation zones

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float atime = time/10.;
	vec2 position = gl_FragCoord.xy/resolution.y-vec2((resolution.x/resolution.y)/2.0,0.5);
	float value = sin(1.0-distance(position,vec2(0.5,0.23))*64.0+atime*8.0)*0.5+0.5;
	position.x+=(-mouse.x+0.5)*1.85;
	position.y+=(-mouse.y+0.5)*1.0;
	float value2 =sin(1.0-distance(position,vec2(0,0))*64.0+atime*8.0)*0.5+0.5;
	//value/=2.0;
	float value4 = (value +value2)/2.;
	float value3 = 101.-exp(abs(1.- (value + value2)))*100.;
	float value5 = abs(value3)+ value3;
	gl_FragColor = vec4(value4+ value5,value4,value4, 1.0 );

}