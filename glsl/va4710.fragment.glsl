#ifdef GL_ES
precision highp float;
#endif

//uniform sampler2D texture;
uniform vec2 resolution;
uniform float time;
uniform sampler2D backbuffer;

float frac(float x) { return mod(x,1.0); }
float noise(vec2 x,float t) { return frac(sin(dot(x,vec2(1.38984*sin(t),1.13233*cos(t))))*653758.5453); }
float step(float x) { return x>0.0?1.0:0.0; }

void main()
{
	float y=gl_FragCoord.y/resolution.y;
	float c=noise(gl_FragCoord.xy,time+texture2D(backbuffer,gl_FragCoord.xy/resolution).r);
	c*=0.2+0.05*step(sin(y*2.0*3.141592+time*9.0)-0.8);
	gl_FragColor=vec4(vec3(c),1.0);
}
