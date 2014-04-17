#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform sampler2D texture;

void main( void ) {
	vec2 position = ( gl_FragCoord.xy -  resolution.xy*.5 ) / resolution.x;
	float t = clamp(time/2.,0.,1.);
	gl_FragColor = (1.0-t)*vec4(position.x,position.y,position.x,1.);
	gl_FragColor += t*texture2D(texture,gl_FragCoord.xy);	
}
	