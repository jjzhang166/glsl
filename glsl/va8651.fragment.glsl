#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	float twoPI = 150.*3.1429;
	float aspectRatio = resolution.x / resolution.y;
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 grid = position * 8.;
	
	float stretchVert = 16.;
	float stretchHori = 6.;
	
	
	float color = 1. - length(mouse.xy - position.xy);
	color += (sin(grid.x * stretchVert));
	color += (cos(grid.y * stretchHori));
	color += smoothstep(.0,1.,position.x);
	color -= smoothstep(1.,.0,position.x);
	//color *= .5 - length(vec2(.5,.5) - position.xy);
	
	float color0 = .5 * position.x * color*(sin(time*.3)+1.);
	float color1 = .5 * position.x * color*(sin(time*.2)+1.);
	float color2 = .5 * position.x * color*(sin(time)+1.);
	
	vec4 o = vec4(color0, color1, color2 ,1.);
	
	gl_FragColor = o;
}