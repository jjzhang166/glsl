#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;



float sphere1(vec3 point)
{
	vec3 m = vec3(0.0,0.0,9000.0);
	float r = 800.0;
	return (length(m-point)-r);
}

float sphere2(vec3 point)
{
	vec3 m = vec3(1900.0,0.0,10000.0);
	float r = 500.0;
	return (length(m-point)-r);
}

float sphere3(vec3 point)
{
	vec3 m = vec3(0.0,1800.0,15000.0);
	float r = 800.0;
	return (length(m-point)-r);
}

float sphere4(vec3 point)
{
	vec3 m = vec3(-1000.0,-3000.0,9000.0);
	float r = 900.0;
	return (length(m-point)-r);
}






float sphere(vec3 point)
{
	return min(min(sphere1(point),sphere2(point)),min(sphere3(point),sphere4(point)));
}


void main( void ) 
{

	gl_FragColor = vec4( 0.0, 0.0, 0.0, 1.0 );

	vec3 position = vec3(1.7,1.0,1.0) * vec3(( gl_FragCoord.xy / resolution.xy ),0.0) - vec3(0.5,0.5,0.0);
	vec3 direction = normalize(position.xyz - vec3(0.0+0.0,0.0,-1.0));
	
	
	float step = 0.0;
	
	for(int iter = 0; iter < 20; ++iter)
	{
		float distf = sphere(position+step*direction); 
		if( distf < 0.1 )
		{
			gl_FragColor = vec4( 1.0, 0.0, 0.0, 1.0 );
			break;
		}
		else
		step += distf;
	}

}