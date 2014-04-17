#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

#define N 3

void main( void ) 
{
	vec2 v = (gl_FragCoord.xy - resolution/2.0) / min(resolution.y,resolution.x) * 20.0;
	
	float t = time*.3;
	float r;
	for ( int i = 0; i < N; i++ ){
//		float d = 3.14159265 / float(N) * 5.0;

		v += vec2(
			  cos(v.y + cos((v.x+t)*2.0)+(mouse.x*1.9)-t) ,
			  sin(v.x + cos((v.y+t)*4.0)+(mouse.y*1.9)-t)  
		);		
	}
	r = length(v);
	gl_FragColor = vec4( cos(r*(sin(mouse.x+3.14159))), cos(r*(sin(mouse.y+3.14159))), cos(r*(cos(mouse.x*mouse.y*3.14159))), 1.0 ) /* *.1+texture2D(backbuffer,gl_FragCoord.xy/resolution)*.9*/;

}