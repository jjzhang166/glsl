#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
float PI = 3.14159265358979323846264;
float TwoPI = PI * 2.0;

vec2 GetPolar(vec2 pos)
{
	vec2 position = (gl_FragCoord.xy / resolution.xy) + pos;
	vec2 origo = vec2(0.5, 0.5);
	vec2 relPos= position-origo;
	float rad= length(relPos);
	float ang= atan(relPos.x, relPos.y) / TwoPI + 0.5;

	return vec2(ang, rad);
}

void main( void ) {

	vec2 pos0= vec2(sin(time*0.4)*0.3, sin(time+0.35)*0.3);
	vec2 pos1= vec2(sin(time*0.3)*0.3, sin(time+0.85)*0.3);

	vec2 polCoord0= GetPolar(pos0);
	vec2 polCoord1= GetPolar(pos1);

	float ang= polCoord0.x + polCoord1.x;
	float rad= polCoord0.y + polCoord1.y;

	rad= rad+sin(rad*10.0+time*1.7)*0.8*
		 sin(rad*1.0+time*0.9)*0.3;

	float c= sin((rad+ang)*PI*16.0)*0.5 + 0.5;

//	if (c > 0.0)
//		c= 1.0;

	gl_FragColor = vec4(c,c,c,1); 

}