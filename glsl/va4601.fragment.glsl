#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;


float sphere(in vec3 rp, in vec3 sp, in float radius)
{	
	return length(rp - sp) - radius;	
}

float getDistance(vec3 p)
{
	float s1 = sphere(p, vec3(0.0, 0.0, 0.0), 2.0);
	
	return s1;
}

void main( void ) {

	vec2 uv = ( gl_FragCoord.xy / resolution.xy );
	vec3 rp = vec3(0.0, 5.0, 10.0);
	vec3 rd = normalize( vec3( -1.0 + 2.0*uv* vec2(resolution.x/resolution.y, 1.0), -1.0 ) );
	const int maxIter = 10;
	
	float t = 0.0;
	
	bool hit = false;
	
	for(int i = 0; i < maxIter; i++)
	{
		float cD = getDistance(rp + rd * t);
		if(cD < 0.001)
		{
			hit = true;
			break;
		}
		t += cD;
	}
	
	if(hit == true)
	{
		gl_FragColor = vec4(0.0, 0.0, 1.0, 1.0);
	}
	else	
	{
		gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
	}
}