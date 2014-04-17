#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 mouse;
uniform vec2 resolution;
vec3 lightColor;
 float screenHeight;
 vec3 lightAttenuation;
 float radius;

uniform sampler2D tex;

void main()
{
	vec2 lightpos = resolution.xy * mouse;
	lightpos.y *= -1.0;
	lightColor = vec3(1.0,1.0,1.0);
	screenHeight = 0.0;
	lightAttenuation = vec3(0.001,0.001,0.001);
	radius = 1.0;
	
	vec2 pixel=gl_FragCoord.xy;
	pixel.y=screenHeight-pixel.y;	
	vec2 aux=lightpos-pixel;
	float distance=length(aux);
	float attenuation=1.0/(lightAttenuation.x+lightAttenuation.y*distance+lightAttenuation.z*distance*distance);	
	vec4 color=vec4(attenuation,attenuation,attenuation,0.0)*vec4(lightColor,0.0);//*radius;	
	gl_FragColor = color;//*texture2D(tex,gl_TexCoord[0].st);
}