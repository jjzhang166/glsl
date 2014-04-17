#ifdef GL_ES
precision mediump float;
#endif

uniform mat4 g_WorldViewProjectionMatrix;
uniform mat4 g_WorldMatrix;
uniform vec3 m_v3CameraPos;		// The camera's current position
uniform vec3 m_v3LightPos;		// The direction vector to the light source
uniform vec3 m_v3InvWavelength;	// 1 / pow(wavelength, 4) for the red, green, and blue channels
uniform float m_fCameraHeight;	// The camera's current height
uniform float m_fCameraHeight2;	// fCameraHeight^2
uniform float m_fOuterRadius;		// The outer (atmosphere) radius
uniform float m_fOuterRadius2;	// fOuterRadius^2
uniform float m_fInnerRadius;		// The inner (planetary) radius
uniform float m_fInnerRadius2;	// fInnerRadius^2
uniform float m_fKrESun;			// Kr * ESun
uniform float m_fKmESun;			// Km * ESun
uniform float m_fKr4PI;			// Kr * 4 * PI
uniform float m_fKm4PI;			// Km * 4 * PI
uniform float m_fScale;			// 1 / (fOuterRadius - fInnerRadius)
uniform float m_fScaleDepth;		// The scale depth (i.e. the altitude at which the atmosphere's average density is found)
uniform float m_fScaleOverScaleDepth;	// fScale / fScaleDepth
uniform vec4 inPosition;
uniform int m_nSamples;
uniform float m_fSamples;
varying vec4 c1;
varying vec4 c0;

float scale(float fCos)
{
	float x = 1.0 - fCos;
	return m_fScaleDepth * exp(-0.00287 + x*(0.459 + x*(3.83 + x*(-6.80 + x*5.25))));
}

void main(void)
{
	// Get the ray from the camera to the vertex and its length (which is the far point of the ray passing through the atmosphere)
	vec3 v3Pos = vec3(g_WorldMatrix * inPosition);
	vec3 v3Ray = v3Pos - m_v3CameraPos;
	float fFar = length(v3Ray);
	v3Ray /= fFar;

	// Calculate the closest intersection of the ray with the outer atmosphere (which is the near point of the ray passing through the atmosphere)
	float B = 2.0 * dot(m_v3CameraPos, v3Ray);
	float C = m_fCameraHeight2 - m_fOuterRadius2;
	float fDet = max(0.0, B*B - 4.0 * C);
	float fNear = 0.5 * (-B - sqrt(fDet));

	// Calculate the ray's starting position, then calculate its scattering offset
	vec3 v3Start = m_v3CameraPos + v3Ray * fNear;
	fFar -= fNear;
	float fDepth = exp((m_fInnerRadius - m_fOuterRadius) / m_fScaleDepth);
	float fCameraAngle = dot(-v3Ray, v3Pos) / length(v3Pos);
	float fLightAngle = dot(m_v3LightPos, v3Pos) / length(v3Pos);
	float fCameraScale = scale(fCameraAngle);
	float fLightScale = scale(fLightAngle);
	float fCameraOffset = fDepth*fCameraScale;
	float fTemp = (fLightScale + fCameraScale);

	// Initialize the scattering loop variables
	float fSampleLength = fFar / m_fSamples;
	float fScaledLength = fSampleLength * m_fScale;
	vec3 v3SampleRay = v3Ray * fSampleLength;
	vec3 v3SamplePoint = v3Start + v3SampleRay * 0.5;

	// Now loop through the sample rays
	vec3 v3FrontColor = vec3(0.0, 0.0, 0.0);
	vec3 v3Attenuate;



}