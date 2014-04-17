#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;void main( void ) {
	vec2 pos = gl_FragCoord.xy / resolution;
	
  gl_FragColor = texture2D(backbuffer, pos);
}
