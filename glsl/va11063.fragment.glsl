#ifdef GL_ES
precision mediump float;
#endif

// suspended illumination by kapsy1312.tumblr.com

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {
    vec2 pos = gl_FragCoord.xy;// / resolution.xy;
    vec4 color = vec4(0.0);
	const float n = 5.0;
	for (float i=0.0; i<n; i+=1.0) {
		color += sin(pos.x*pos.y*i+time) / n;
	}
    
    gl_FragColor = (color) + texture2D(backbuffer, vec2(gl_FragCoord.y,gl_FragCoord.x)) *.9;
}
