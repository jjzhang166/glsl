#ifdef GL_ES
precision mediump float;
#endif
// mods by dist

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


void main( void )
{

	vec2 uPos = ( gl_FragCoord.xy / resolution.xy );
	
	uPos.x -= mouse.x;
	uPos.y -= 0.5; //mouse.y;
	
	vec3 color = vec3(0.0);
	float vertColor = 0.0;

	uPos.y += sin(uPos.x*time/mouse.x/5.0+(uPos.y*time/500.0))*cos(time*3.0)/2.0+uPos.y;
	float fTemp = abs(1.0 / (uPos.y*1.5 / (uPos.x*20.0) ) / time*2.0 );
	vertColor += fTemp;
	color += vec3( fTemp*(5.0)/2.0, fTemp/5.0, pow(fTemp,2.0)*5.0 );
	
	vec4 color_final = vec4(color, 1.0);
	gl_FragColor = color_final;
}