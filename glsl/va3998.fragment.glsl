#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float twopi = 6.283185307179586;
	vec2 pos = ( gl_FragCoord.xy / resolution.xy );

	pos.x=pos.x*twopi+time*0.1;
	vec3 pos3 = vec3(pos.x) + vec3(0.0,twopi*1.0/3.0,twopi*2.0/3.0);
	vec3 color = vec3(cos(pos3)*0.5+0.5);
	color = step(pos.y, color);
	//color = pow(color, vec3(1.0/2.2));
	gl_FragColor = vec4( color.x,color.y,color.z, 1.0);
}