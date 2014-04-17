#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec4 sph1 = vec4(0, 1, 0, 1);
vec4 sph2 = vec4(0, 0.5, 0, 0.5);


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
	float tSphere2 = iSphere(ro, rd, sph2);		// intersect with glass sphere
	float tPlane = iPlane( ro, rd ); 	// insersect with plane
	
	if(tSphere > 0.0)
	{
		id = 1.0;
		resT = tSphere;
	}
	if(tSphere2 > 0.0 && tSphere2 < resT)
	{
		id = 2.0;
		resT = tSphere2;
	}
	if(tPlane > 0.0 && tPlane < resT)
	{
		id = 3.0;
		resT =  tPlane;
	}
	
	return id;
}

float checkerTex(vec2 uv, float size, float hardness) 
{
	float xCheck = sin(uv.x*size)*hardness;
	float yCheck = sin(uv.y*size)*hardness;
	return clamp(xCheck*yCheck, 0.0, 1.0);	
}

vec3 squirliesTex(vec2 uv) 
{
	float sum = 0.;
	float qsum = 0.;
	
	for (float i = 0.; i < 100.; i++) {
		float x2 = i*i*.3165+(mouse.x*i*0.01)+.5;
		float y2 = i*.161235+(mouse.y*i*0.01)+.5;
		vec2 p = fract(uv-vec2(x2,y2))-vec2(.5);
		float a = atan(p.y,p.x);
		float r = length(p)*100.;
		float e = exp(-r*.5);
		sum += sin(r+a+time)*e;
		qsum += e;
	}
	
	float color = sum/qsum;
	
	return vec3(color,color-.5,-color);
}

vec3 colorPlane(vec3 ro, vec3 rd, float t)
{ 
	vec3 pos = ro + t*rd;	
		
	float dif = length(pos.xz-sph1.xz);
	float oblique = pow(-dot(rd, vec3(0.0, 1.0, 0.0)), 1.0)+0.7;
	float checker = checkerTex(vec2(pos.x, pos.z), 4.0, 20.0);

	checker = mix(0.3, checker, oblique);
	
	return vec3(1.0)*dif*squirliesTex(vec2(pos.x, pos.z)*0.1);	
}

vec3 skyColor(vec3 rd)
{
	return mix(vec3(0.9, 0.9, 1.0), vec3(0.0, 0.0, 0.5), rd.y);
}

vec3 colorChromeSphere(vec3 ro, vec3 rd, float t)
{
	vec3 pos = ro + t*rd;
	vec3 n = nSphere( pos, sph1 );
	
	float refT;
	float refID = intersect(pos, n, refT);
	
	vec3 refCol = vec3(0.0);
	if(refID>1.5)
		refCol = colorPlane(pos, n, refT);
	else 
		refCol = skyColor(n);
	
	float fresnel = clamp(pow(1.0+dot(rd, n), 1.5), 0.1, 1.0);

	return refCol*fresnel;	
}

vec3 colorGlassSphere(vec3 ro, vec3 rd, float t)
{
	vec3 pos = ro + t*rd;
	vec3 n = nSphere( pos, sph2 );
	
	float IOR = 5.0;
	vec3 refractVector = refract(rd, n, IOR);
	float refractT = iSphere(pos, refractVector, sph2);	// refract front of sphere
	vec3 backOfSpherePos = pos + refractVector*refractT;
	vec3 backOfSphereNormal = nSphere(backOfSpherePos, sph2);
	refractVector = refract(backOfSpherePos, backOfSphereNormal, 1.0/IOR);
	
	float refractID = intersect(backOfSpherePos+refractVector*0.01, refractVector, refractT);
	vec3 refCol = vec3(0.0);
	
	if(refractID>0.0 && refractID < 1.5)
		refCol = colorChromeSphere(pos, refractVector, refractT);
	if(refractID>1.5 && refractID<2.5)
		refCol = colorPlane(pos, n, refractT);
	else if(refractID>2.5)
		refCol = colorPlane(pos, n, refractT);
	else
		refCol = skyColor(n);
	
	//refCol = colorChromeSphere(pos, refractVector, refractT);	
	float fresnel = clamp(pow(1.0+dot(rd, n), 1.5), 0.1, 1.0);

	return refCol;	
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
	sph2.x = sph1.x - 2.0*cos(time);
	sph2.z = sph1.z + 2.0*sin(time);
	
	// we intersect the ray with the 3d scene
	float t;
	float id = intersect( ro, rd, t );
	
	vec3 col = vec3(0.0);							// Draw black by default
	
	if(id>0.5 && id<1.5)							// Hit sphere
		col = colorChromeSphere(ro, rd, t);
	else if(id>1.5 && id< 2.5)
		col = colorGlassSphere(ro, rd, t);
	else if(id>2.5)								// Hit plane
		col = colorPlane(ro, rd, t);
	else
		col = skyColor(rd);
	
	gl_FragColor = vec4( col, 1.0 );

}