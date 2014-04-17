#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	//vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	vec2 pos = vec2(100.0,100.0);
	
	float l = distance(pos,gl_FragCoord.xy);
	
	if(l > 50.0){
		gl_FragColor = vec4(0,0,0,0);
	}else{
		gl_FragColor = vec4(1,0,0,0);}		
	
	//gl_FragColor = vec4(1,0,0,0.5);

}