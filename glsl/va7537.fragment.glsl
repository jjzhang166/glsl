#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

#define N 12

void main( void ) 
{
	vec2 v = (gl_FragCoord.xy - resolution/2.0) / min(resolution.y,resolution.x) * 20.0;
	
	float t = time*.1;
	float r;
	for ( int i = 0; i < 142; i++ ){
		float d = 3.14159265 / float(182) * 5.0;
		r = length(v);
		v += vec2(cos(v.y+cos(r)), -sin(v.x+cos(r)) - sin(t));
	}

	gl_FragColor = vec4( cos(r*0.5), cos(r*1.0), cos(r*2.0), 1.0 )*.1+texture2D(backbuffer,gl_FragCoord.xy/resolution)*.9;

}