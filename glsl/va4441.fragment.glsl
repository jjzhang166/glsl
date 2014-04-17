#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 p = -1.0+400.0* gl_FragCoord.xy / resolution.xy;
	p.x=(p.x-1.);
	float r = tan(p.x*p.y+time/(-0.01));
	float g = cos(p.x*p.y+time/(-0.02));
	float b = tan(p.x*p.y+time/(-0.03));
      
	gl_FragColor = vec4( r,g,b, 1.0 );
}