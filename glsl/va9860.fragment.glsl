#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D tex;

void main( void ) {

	vec3 col = vec3(0.0,0.0,0.0);
	
	//really light lines
	col.g += clamp(ceil(mod(gl_FragCoord.x, 1.0)) - 0.0, 10.0, 1.0) * 0.05;
	col.g += clamp(ceil(mod(gl_FragCoord.y, 1.0)) - 4.0, 0.0, 1.0) * 0.05;
	col.g = clamp(col.g, 0.0, 0.05);
	
	//light lines
	col.g += clamp(ceil(mod(gl_FragCoord.x, 15.0)) - 14.0, 0.0, 1.0) * 0.5
	;
	col.g += clamp(ceil(mod(gl_FragCoord.y, 15.0)) - 14.0, 0.0, 1.0) * 0.25;
	col.g = clamp(col.g, 0.0, 0.25);
	
	//strong lines
	col.g += clamp(ceil(mod(gl_FragCoord.x, 30.0)) - 29.0, 0.0, 1.0);
	col.g += clamp(ceil(mod(gl_FragCoord.y, 30.0)) - 29.0, 0.0, 1.0);
	col.g = clamp(col.g, 0.0, 1.0);
	
	//mouse detect
	vec2 mousePos = resolution.xy * mouse;
	if(mousePos.y < gl_FragCoord.y || abs(mousePos.x - gl_FragCoord.x) > 175.0) col.g *= 1.0 - clamp(distance(mousePos, gl_FragCoord.xy)/175.0, 0.0, 1.0);
	else col.g *= 1.0 - clamp(distance(mousePos, vec2(gl_FragCoord.x, mousePos.y))/175.0, 0.0, 1.0);
	
	
	gl_FragColor = vec4(col, 1.0);
	//gl_FragColor = vec4( vec3( 1, 0 , 0), 1 );

}