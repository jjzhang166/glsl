#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float sdSphere(vec3 p, float s)
{
  return length(p)-s;
}

void main(void) {
	
	float d = sdSphere(vec3(vec2(0.3, 0.3) + gl_FragCoord.xy/resolution.xy, 1.0), 0.3);
	
	
	gl_FragColor = vec4(d, 1.0, 0.0, 1.0);
}