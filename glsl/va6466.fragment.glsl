#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float mouseRadius = 0.01;
const vec2 mouseOffset = vec2(0.0,0.01);

void main( void ) {
	vec2 uv = gl_FragCoord.xy/resolution.xy;
	vec2 position = (uv) + mouse / 4.0;

	float color = 0.0;
	color += sin( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
	color += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
	color += sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	color *= sin( time / 10.0 ) * 0.5;

	float dist = distance(mouse+mouseOffset,uv);
	
	vec4 bgColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );
	
	if(dist < mouseRadius){
		gl_FragColor = vec4(mix(bgColor,vec4(1.0,0.0,0.0,1.0),smoothstep(1.0,0.0,dist/mouseRadius)));
	}else{	
		gl_FragColor = bgColor;
	}
}