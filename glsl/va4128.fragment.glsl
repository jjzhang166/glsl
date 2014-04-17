#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


void main( void )
{

	vec2 uPos = ( gl_FragCoord.xy / resolution.xy ) - 0.5;//normalize wrt y axis
	
	float theta = mouse.x*3.0;
	uPos = vec2(uPos.x * cos(theta) - uPos.y * sin(theta), uPos.x * sin(theta) - uPos.y * cos(theta));
	
	float v = cos( (sin(time) + 2.0) * uPos.x * 53.0) * 5.0;
	
	float c = abs(1.0 / (v - uPos.y) / 1.0);
	
	vec4 color = vec4( (cos(time) + 1.0) * c*1.5, c, c * 2.5, 1.0 );
	gl_FragColor = color;
}