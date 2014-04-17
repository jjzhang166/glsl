#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

vec4 checker2D(vec3 texc, vec4 color0, vec4 color1)
{
  if (mod((floor(texc.x) + floor(texc.y)),2.0) == 0.0)
    return color0;
  else
    return color1;
}
vec2 center = vec2(0.5,0.5*resolution.y/resolution.x);
vec3 RotateZ( const in vec3 vPos, const in float fAngle )
{
	float s = sin(fAngle);
	float c = cos(fAngle);
	
	vec3 vResult = vec3( c * vPos.x + s * vPos.x, -s * vPos.y + c * vPos.y, vPos.y);
	
	return vResult;
}
void main( void ) 
{
	vec2 position = gl_FragCoord.xy/resolution+vec2(-0.5);
	position *= vec2(50.,50.*resolution.y/resolution.x);
	vec2 mousep = mouse;// * vec2(50.,50.*resolution.y/resolution.x);
	float color = distance(mouse,gl_FragCoord.xy/resolution.xy)*4.0;
		position.xy += RotateZ(vec3(position,1.0), time/20.0+0.1*distance(position, vec2(0,0))).xy;
	gl_FragColor = checker2D(vec3(position,0)*0.6,vec4(1),vec4(0))+0.05*texture2D(backbuffer, gl_FragCoord.xy/resolution.xy);
}