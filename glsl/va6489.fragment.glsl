precision mediump float;


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 center = vec2(0.5,0.5*resolution.y/resolution.x);

vec3 RotateX( const in vec3 vPos, const in float fAngle )
{
	float s = sin(fAngle);
	float c = cos(fAngle);
	
	vec3 vResult = vec3( vPos.x, c * vPos.y + s * vPos.z, -s * vPos.y + c * vPos.z);
	
	return vResult;
}
 
vec3 RotateY( const in vec3 vPos, const in float fAngle )
{
	float s = sin(fAngle);
	float c = cos(fAngle);
	
	vec3 vResult = vec3( c * vPos.x + s * vPos.z, vPos.y, -s * vPos.x + c * vPos.z);
	
	return vResult;
}
     
vec3 RotateZ( const in vec3 vPos, const in float fAngle )
{
	float s = sin(fAngle);
	float c = cos(fAngle);
	
	vec3 vResult = vec3( c * vPos.x + s * vPos.y, -s * vPos.x + c * vPos.y, vPos.z);
	
	return vResult;
}
void main()
{
	vec2 position = gl_FragCoord.xy/resolution+vec2(-0.5);
	position *= vec2(50.,50.*resolution.y/resolution.x);
	position.xy += RotateZ(vec3(position,1.0), time+0.1*distance(position, vec2(0,0))).xy;

	vec3 color = floor(mod(position.x,2.0)) * floor(mod(position.y, 2.0)) *  vec3(0.5,0,0)
		+ floor(mod(position.y, 2.0)) * floor(mod(position.x,1.0)) * vec3(0,0,0.5);

	gl_FragColor = vec4(color,1.0);
}