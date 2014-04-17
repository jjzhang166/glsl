// @rotwang: @mod+
// modified showing use of step and smoothstep instead of if

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy );

	float red = 0.1;
	float green = 0.1;
	float blue = 0.1;
	
	
	//if(pos.x<0.5) red=0.5;
	//if(pos.y<0.5) blue=0.5;

	//red = step(pos.x, 0.5) *0.5;
	//blue = step(pos.y, 0.5) *0.5;
	
	red = smoothstep(0.49,0.51, 1.0-pos.x) *0.5;
	blue = smoothstep(0.49,0.51, 1.0-pos.y) *0.5;
	
	gl_FragColor = vec4( vec3(red,green,blue),1.0 );
}