#ifdef GL_ES
precision mediump float;
#endif

uniform float time;

float rand(vec2 n)
{
  return 0.5 + 0.5 * 
     fract(sin(dot(n.xy, vec2(12.9898, 78.233)))* 43758.5453);
}

void main(void)
{
	float t = sin(time);
	gl_FragColor = vec4(rand(vec2(t, t)), rand(vec2(t-0.5, t)), rand(vec2(t, t-0.5)), 0.0);
}
