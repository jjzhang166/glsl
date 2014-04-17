
#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

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

float cone( vec3 p, vec2 c)
{
float q = length(p.xy);
    return dot(c,vec2(q,p.z));
}
float map( vec3 p )
{
	
    	return length(p)-.04;
}

void main( void )
{
    	vec2 pos = (gl_FragCoord.xy*2.0 - resolution.xy) / resolution.y;
    	vec3 camPos = vec3(0., 0., 0.1);
    	vec3 camTarget = vec3(0.0, 0.0, 0.0);

    	vec3 camDir = normalize(camTarget-camPos);
    	vec3 camUp  = normalize(vec3(0.0, 1.0, 0.0));
    	vec3 camSide = cross(camDir, camUp);
    	float focus = 2.0;

	vec3 rayDir = normalize(camSide*pos.x + camUp*pos.y + camDir*focus);
    	vec3 ray = camPos;
    	float d = 0.0, total_d = 0.0;
 	const int MAX_MARCH = 32;
 	const float MAX_DIST = 0.2;
	vec4 result;
	int i;
	
    	for(int i=0; i<MAX_MARCH; ++i) {
        	d = map(ray);
        	total_d += d;
        	ray += rayDir * d;
        	if(abs(d)<0.001) {
			break;
		}
		if(total_d > float(MAX_DIST)) {
			total_d = float(MAX_DIST);
			break;
		}
    	}
	
	result = vec4(1. - (total_d / MAX_DIST),0.,0.,1.);
	gl_FragColor = result;
}