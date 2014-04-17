#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float numbahone = cos((position.x + (time*0.1) ) * 10.0 ) * 0.1 + 0.55 + sin(time) * 0.1;
	float numbahtwo = cos((position.x + (time*0.1) )* 6.28 ) * 0.1 + 0.3 + cos(time) * 0.2;
        float dist_one = abs(position.y - numbahone);
        float dist_two = abs(position.y - numbahtwo);
	
	float red = 0.0;
	float green = 0.0;
	float blue = 0.0;

	if ( position.y < numbahone && position.y > numbahtwo )
		red = 1.0;

	if ( dist_one < 0.1 )
		blue = dist_one / 0.1;
	if ( dist_two < 0.1 )
		green = dist_two / 0.1;
	
	
	
	
	gl_FragColor = vec4( red * 0.5, green*0.5, blue*0.5, 1.0 );

}