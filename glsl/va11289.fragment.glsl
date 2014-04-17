#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 c = (( gl_FragCoord.xy / resolution.xy ) - vec2(.5,.5)) * 3.; // from http://thndl.com/?5
	vec2 r=abs(c.xy);
        float s=step(.5,max(r.x,r.y)); 
	gl_FragColor = vec4(vec3(s),1.);
}