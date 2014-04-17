#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec4 sph1 = vec4(0, 1, 0, 1);

float iSphere (in vec3 ro, in vec3 rd, vec4 sph )
{
	// equation of a plane, y=0 = ro.y + t*rd.y
	// meaning |xyz|^2 = r^2 meaning <xyz, xyz> = r^2
	// xyz = ro + t*rd, therefore  |ro|^2 + t^2 + 2<ro, rd>t - r^2 = 0
	
	vec3 pos = ro - sph.xyz;
	float r = 1.0;
	float b = 2.0*dot( pos, rd );
	float c = dot(pos, pos) - sph.w*sph.w;
	float h = b*b - 4.0*c;
	
	if(h< 0.0) return -1.0;
	
	float t = (-b - sqrt(h))/2.0;
	return t;
}

vec3 nSphere( in vec3 pos, in vec4 sph ) 
{
	return (pos - sph.xyz)/sph.w;
}



float iPlane (in vec3 ro, in vec3 rd )
{
	// a sphere centered at the origin has equation |xyz| = r
	// meaning |xyz|^2 = r^2 meaning <xyz, xyz> = r^2
	// xyz = ro + t*rd, therefore  |ro|^2 + t^2 + 2<ro, rd>t - r^2 = 0
	
	return -ro.y/rd.y;
}

vec3 nPlane( vec3 pos )
{
	return vec3(0, 1, 0);
}

float intersect( in vec3 ro, in vec3 rd, out float resT )
{
	resT = 1000.0;
	float id = -1.0;
	float tSphere = iSphere( ro, rd, sph1 ); 	// intersect with a sphere
	float tPlane = iPlane( ro, rd ); 	// insersect with plane
	
	if(tSphere > 0.0)
	{
		id = 1.0;
		resT = tSphere;
	}
	if(tPlane > 0.0 && tPlane < resT)
	{
		id = 2.0;
		resT =  tPlane;
	}
	
	return id;
}



void main( void ) {

	vec3 lightDir = normalize(vec3(1,1,0));
	
	//uv are the pixel coordinates from 0 to 1
	vec2 uv = (gl_FragCoord.xy / resolution.xy);
	vec2 aspectRatio = vec2(1.5, 1.0);
	
	// generate camera ray
	vec3 ro = vec3( 0.0, 0.5, 4.0 );					// origin 1 unit in front of the screen
	vec3 rd = normalize( vec3( (-1.0+2.0*uv)*aspectRatio, -1.0));		// shoot ray through screenpixel
	
	// Move the sphere!
	sph1.x = cos(time);
	sph1.z = sin(time);
	
	
	// we intersect the ray with the 3d scene
	float t;
	float id = intersect( ro, rd, t );
	
	vec3 col = vec3(0.0);							// Draw black by default
	
	if(id>0.5 && id<1.5)
	{
		vec3 pos = ro + t*rd;
		vec3 n = nSphere( pos, sph1 );
		float dif = 0.5 + 0.5*dot(n, lightDir);
		
		vec3 ambient = vec3(0.5, 0, 0)*-n.y;
		
		col = vec3(0.4, 0.2, 0.8)*dif+ambient;
		
	}
	else if(id>1.5)
	{
		vec3 pos = ro + t*rd;
		
		float dif = length(pos.xz-sph1.xz);
		col = vec3(1,0,0)*dif;
	}
	
	gl_FragColor = vec4( col, 1.0 );

}