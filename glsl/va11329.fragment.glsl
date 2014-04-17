#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 c = (( gl_FragCoord.xy / resolution.xy ) - vec2(.5,.5)) * 3.; // from http://thndl.com/?5
        float r=length(max(abs(c.xy)-.3,0.));
	gl_FragColor = vec4(r,r,r,0.5);

}