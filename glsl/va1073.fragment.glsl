// mix - @P_Malin

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

uniform sampler2D backbuffer;

#define PI 3.141592654

void main( void ) 
{
	vec2 vPos = ( gl_FragCoord.xy / resolution.xy );

	// distort previous frame with a magic wibble
	float fFreq = sin(time* 15500.0) * 0.005 + 0.8;
	float fMag = 0.01;
	vec2 vParam = vPos * PI * 4.0 * fFreq;	
	vec2 vUV = vPos;
	vUV += vec2(sin(vPos.y * PI * 9.0 * fFreq + time * 0.3), sin(vPos.x * PI * 9.0 * fFreq - time * 0.2)) * fMag;
	
	vec3 last1 = texture2D(backbuffer, vUV + vec2(0.5, 0.0) / resolution).rgb;
	vec3 last2 = texture2D(backbuffer, vUV - vec2(0.5, 0.0) / resolution).rgb;
	vec3 last3 = texture2D(backbuffer, vUV + vec2(0.0, 0.5) / resolution).rgb;
	vec3 last4 = texture2D(backbuffer, vUV - vec2(0.0, 0.5) / resolution).rgb;
	vec3 last = (last1 + last2 + last3 + last4) * 0.25;
	vec3 result = last;

	// draw a colourful blob over the top
	vec2 vSeedPos = mouse;
	vec2 vDelta = vPos - vSeedPos;
	float fLen = length(vDelta);
	if(fLen < 0.04)
	{
		float fAngle = atan(vDelta.x, vDelta.y) + time;
		float fRed = sin(fAngle);
		float fGreen = sin(fAngle + PI * 2.0 * 0.3333);
		float fBlue = sin(fAngle + PI * 2.0 * 0.6666);
		result = vec3(fRed, fGreen, fBlue) * 0.5 + 0.5 + ((0.04 - fLen) / 0.04);
	}
	
	
	gl_FragColor = vec4( result, 1.0 );

}