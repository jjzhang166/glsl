#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 mousePos = resolution.xy*mouse.xy;
	float color = 0.0;
	vec2 var = gl_FragCoord.xy-mousePos;//resolution.xy/2.0;
	float mag = sqrt(var.x*var.x+var.y*var.y);
	color = (sin(mag/5.0+time*(10.0))+1.0)/2.0;
	gl_FragColor = vec4(color,color,color,1);

}