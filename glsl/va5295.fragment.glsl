//LOLOLOL
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float bubble(vec2 pos) {
	float Fcolor = 0.0;
	vec2 point = vec2(distance(gl_FragCoord.xy,pos.xy), sin(distance(gl_FragCoord.xy, pos.xy)/(112.0+sin(time*20.0)*100.0)-1.0)); 
	Fcolor += (1.0-smoothstep(40.0, 40.0 + ((sin(time*5.0)+1.0)*50.0), point.x))*point.y;
	return Fcolor;
}

void main( void ) {

	vec2 position = vec2(resolution.x*mouse.x, resolution.y*mouse.y);
	float color = 0.0;
	color = bubble(position);

	gl_FragColor = vec4( vec3( color * time, color * sin(time*20.0), color * sin(time*3000.0)), 1.0 );

}