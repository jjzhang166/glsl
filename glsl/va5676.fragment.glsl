#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D backbuffer;
uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;

void main() {
	float g = .005;
  vec2 gap = vec2(g, g);
  
vec2 uv = gl_FragCoord.xy/resolution;
	float aspect = resolution.x/resolution.y;
float n = 1.;
  vec4 val = texture2D(backbuffer, uv);
  vec4 dd = (texture2D(backbuffer, uv + vec2(gap.x, gap.y)) +
             texture2D(backbuffer, uv + vec2(-gap.x, gap.y)) +
             texture2D(backbuffer, uv + vec2(gap.x, -gap.y)) +
             texture2D(backbuffer, uv + vec2(-gap.x, -gap.y))) *.25;

  float bla = 0.;

	vec2 dotPos = vec2(sin(time), cos(time))*0.2+0.5;
	if(length((dotPos-uv)*vec2(aspect, 1))<.01) bla = 1.;

	
  gl_FragColor = dd+vec4(bla);
}