#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {
	vec2 pos = gl_FragCoord.xy / resolution;
	if(time<0.5){
		float col=.0;
		float sum = floor(pos.x*10.0) + floor(pos.y*10.0);
		if(mod(sum,2.0)==1.0){
			col=1.0;
		}
		gl_FragColor = vec4(col);
		return;
	} else {
		gl_FragColor = 1.0 - texture2D(backbuffer, pos);
	}
}