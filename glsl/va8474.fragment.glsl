#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
const int sources = 16;
void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse;

	float val = 0.0;
	for(int i = 0; i < sources; i++) {
	  float fi = float(i);
	  vec2 srcpos = vec2(cos(fi*2.0 + time*0.1)*0.5 + 1.0, sin(fi*3.0 + time*0.1)*0.5 + 1.0);
	  float dis = distance(srcpos, position);
	  val += sin(dis*128.0*(1.0 + sin(time)*0.1) + time*0.1);
	}
	gl_FragColor = vec4(val, val + sin(time + 4.0)*0.5, val + sin(time + 6.0)*0.5, 1);
}