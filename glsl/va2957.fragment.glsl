#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float power = /*2.*/(resolution.x / mouse.x)/(resolution.y / mouse.y);

	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	float v=p.x,w=p.y;

	if (pow(v,power)-w>0.) discard;
	gl_FragColor=vec4(0.,mouse.x/w,mouse.x/v,1.);
}
