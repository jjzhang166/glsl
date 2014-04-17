#ifdef GL_ES
precision highp float;
#endif

//uniform sampler2D texture;
uniform vec2 resolution;
uniform float time;

float frac(float x) { return mod(x,1.0); }
float noise(vec2 x,float t) { return frac(sin(dot(x,vec2(1.38984*sin(t),1.13233*cos(t))))*653758.5453); }

const float intensity=0.5;

void main()
{
	float y=gl_FragCoord.y/resolution.y;

	vec2 screencoords=floor(gl_FragCoord.xy/2.0);
	vec2 fraccoords=fract(gl_FragCoord.xy/2.0);
	float c1=noise(screencoords+vec2(0.0,0.0),time);
	float c2=noise(screencoords+vec2(1.0,0.0),time);
	float c3=noise(screencoords+vec2(0.0,1.0),time);
	float c4=noise(screencoords+vec2(1.0,1.0),time);
	float c=mix(mix(c1,c2,fraccoords.x),mix(c3,c4,fraccoords.x),fraccoords.y);

	c*=0.8+0.2*clamp(sin(y*2.0*3.141592+time*9.0)-0.4,0.0,1.0);
	c*=intensity;
	gl_FragColor=vec4(vec3(c),1.0);
}
