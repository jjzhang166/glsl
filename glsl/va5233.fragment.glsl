// the.savage@hotmail.co.uk

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;

vec4 pack(const float f)
{
	float a=fract(f*255.0);
	float b=fract(a*255.0);
	float c=fract(b*255.0);

	if(gl_FragCoord.y>resolution.y*0.5)
		return vec4(f,a,b,c);

//	Q: depth buffer packing, anyone know why bias below is needed?
//         is it only for certain hardware?

	vec4 v=vec4(f,a,b,c);
	return v-(v.yzww*vec4(1.0/255.0,1.0/255.0,1.0/255.0,0.0));
}

float unpack(const vec4 v)
{
	return dot(v,vec4(1.0,1.0/255.0,1.0/(255.0*255.0),1.0/(255.0*255.0*255.0)));
}

void main(void)
{
	float fScale=10.0; //gl_FragCoord.y*1000.0;
	float fValue=(gl_FragCoord.x/resolution.x)*fScale;

	vec4 vPack=pack(fValue);
	float fUnpack=unpack(vPack)/fScale;

	gl_FragColor=vec4(vec3(fUnpack),1.0);
}
