#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;

float function(vec3 p)
{
	float x = p.x, y = p.y, z = p.z;
	
	return z*y;
}

bool intersect(in vec3 ro, in vec3 rd, out float resT)
{
	const float dMIN = 0.0;
	const float dMAX = 6.0;
	const float DELTA = 0.01;
	
	for (float t = dMIN; t < dMAX; t+=DELTA)
	{
		float h = function(ro+rd*t);
		if (h < .001)
		{
			resT = t;
			return true;
		}
	}
	
	return false;
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 ratio = vec2( resolution.x / resolution.y );

	vec3 color = vec3(0);
	
	vec3 ro = vec3(0,0,-3.);
	vec3 rd = normalize(vec3((-2.+1.*position),-1.));
	
	float t;	

	if (intersect(ro,rd,t))
	{
		color = vec3(1);
	}
	
	gl_FragColor = vec4( color, 1.0 );

}