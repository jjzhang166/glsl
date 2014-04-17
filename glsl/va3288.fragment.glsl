// rotwang: @mod* nice colors while playing with mod

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	float aspect = resolution.x / resolution.y;
	vec2 unipos =  gl_FragCoord.xy / resolution ;
	vec2 pos = unipos*2.0-1.0;
	pos.x *= aspect;
	
	float mr = mod(pos.x, 0.5);
	float mg = mod(pos.x, 0.25);
	float r = abs(mr);
	float g = abs(mg);
	float b = abs(pos.y)*0.5;
	
	gl_FragColor = vec4( r, g, b, 1.0);

}