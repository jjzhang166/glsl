#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	//if distance from center is RADIUS, draw white, else black
	
	vec2 center = vec2(0.5);
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec4 color;
	float RADIUS = 0.3*sin(time)*cos(time)+0.3;
	
	float dist = distance(position,center);
	
	if(dist<RADIUS) {
		color=vec4(sin(time),cos(time),1.,1.0)*(RADIUS-dist)/RADIUS*1.5;
	} else {
		color=vec4(0.0);
		color.a=1.0;
	}

	gl_FragColor = color;
}