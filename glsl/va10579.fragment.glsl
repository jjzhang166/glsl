#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;
int step=6;

void main(void) {
	vec2 uv = (gl_FragCoord.xy / resolution.xy)*2.0-1.0;
	float time= time + 0.5 ;
	float a = atan(uv.x,uv.y);
	float b = 6.28319/float(step);
	float f=smoothstep(0.5,0.51,cos(floor(0.5+a/b)*b-a)*length(uv));
	float g=smoothstep(0.48,0.485,cos(floor(0.5+a/b)*b-a)*length(uv));
	g = 1.0 - g;
	f += g;
	gl_FragColor = vec4(f,f,f,1.0);
}