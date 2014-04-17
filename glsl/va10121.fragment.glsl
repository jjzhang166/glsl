#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI          3.14159265358979323846

void main( void ) {

	vec2 e = mouse / 2.0;
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 2.0;
	
	vec4 color1 = vec4( 1.0, 1.0, 0.0, 1.0 );
	vec2 pos1 = vec2( e.x*2.0, e.y*2.0 );
	//vec2 pos1 = vec2( 0.9, 0.8 );
	//vec2 pos1 = vec2( 0.1, 0.9 );
	
	vec4 color2 = vec4( 0.0, 1.0, 0.0, 1.0 );
	//vec2 pos2 = vec2( 1.0 - e.x, e.y );
	vec2 pos2 = vec2( 0.9, 0.8 );
	//vec2 pos2 = vec2( 0.9, 0.9 );
	
	vec4 color3 = vec4( 1.0, 0.0, 1.0, 1.0 );
	//vec2 pos3 = vec2( 1.0 - e.x, 1.0 - e.y );
	vec2 pos3 = vec2( 0.9, 0.3 );
	//vec2 pos3 = vec2( 0.1, 0.1 );
	
	vec4 color4 = vec4( 0.0, 0.0, 1.0, 1.0 );
	//vec2 pos4 = vec2( e.x, 1.0 - e.y );
	//vec2 pos4 = vec2( 1800.0, 324.0 );
	vec2 pos4 = vec2( 0.9, 0.1 );
	
	//float d1 = pow( distance(  gl_FragCoord.xy / resolution.xy, pos1 ), 1.0 );
	//float d2 = pow( distance(  gl_FragCoord.xy / resolution.xy, pos2 ), 1.0 );
	//float d3 = pow( distance(  gl_FragCoord.xy / resolution.xy, pos3 ), 1.0 );
	//float d4 = pow( distance(  gl_FragCoord.xy / resolution.xy, pos4 ), 1.0 );
	
	/*if(pos1 == pos2)
		pos2.x += 0.001;
	if(pos1 == pos3)
		pos3.x += 0.001;
	if(pos1 == pos4)
		pos4.x += 0.001;
	if(pos2 == pos3)
		pos3.x += 0.001;
	if(pos2 == pos4)
		pos4.x += 0.001;
	if(pos3 == pos4)
		pos4.x += 0.001;*/
	

	float d1 = 1.0/sqrt( pow( 0.1 *( (gl_FragCoord.x / resolution.x) -  pos1.x ), 2.5 ) + pow( 0.1 * resolution.y / resolution.x, 2.5 ) * pow( 0.3 *( gl_FragCoord.y / resolution.y -  pos1.y ), 2.0 ) );// / log( 10.0 );5
	float d2 = 1.0/sqrt( pow( 0.1 *( (gl_FragCoord.x / resolution.x) -  pos2.x ), 2.5 ) + pow( 0.1 * resolution.y / resolution.x, 2.5 ) * pow( 0.3 *( gl_FragCoord.y / resolution.y -  pos2.y ), 2.0 ) );// / log( 10.0 );
	float d3 = 1.0/sqrt( pow( 0.1 *( (gl_FragCoord.x / resolution.x) -  pos3.x ), 2.5 ) + pow( 0.1 * resolution.y / resolution.x, 2.5 ) * pow( 0.3 *( gl_FragCoord.y / resolution.y -  pos3.y ), 2.0 ) );// / log( 10.0 );
	float d4 = 1.0/sqrt( pow( 0.1 *( (gl_FragCoord.x / resolution.x) -  pos4.x ), 2.5 ) + pow( 0.1 * resolution.y / resolution.x, 2.5 ) * pow( 0.3 *( gl_FragCoord.y / resolution.y -  pos4.y ), 2.0 ) );// / log( 10.0 );
	
	float t = d1 + d2 + d3 + d4;
	
	gl_FragColor = ( (color1 * d1 / t) + (color2 * d2 / t) + color3 * d3 / t + color4 * d4 / t );// * ( d1 + d2 + d3 + d4 );
	
	// ax + by +c = 0

}