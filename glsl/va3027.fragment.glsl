// Eyeballs!  STolen from my neighbor :)  - BigWings

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec4 sph1 = vec4(0, 1, 0, 1);
vec4 sph2 = vec4(0, 0.7, 0, 0.7);

float hash( float n )
{
    return fract(sin(n)*43758.5453);
}

float noise( in vec2 x )
{
    vec2 p = floor(x);
    vec2 f = fract(x);
    f = f*f*(3.0-2.0*f);
    float n = p.x + p.y*57.0;
    float res = mix(mix( hash(n+  0.0), hash(n+  1.0),f.x), mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y);
    return res;
}

mat2 m = mat2( 0.80,  0.60, -0.60,  0.80 );

float fbm( vec2 p )
{
    float f = 0.0;
    f += 0.50000*noise( p ); p = m*p*2.02;
    f += 0.25000*noise( p ); p = m*p*2.03;
    f += 0.12500*noise( p ); p = m*p*2.01;
    f += 0.06250*noise( p ); p = m*p*2.04;
    f += 0.03125*noise( p );
    return f/0.984375;
}

float length2( vec2 p )
{
    float ax = abs(p.x);
    float ay = abs(p.y);
    return pow( pow(ax,4.0) + pow(ay,4.0), 1.0/4.0 );
}

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
		float x2 = i*i*.3165+(i*0.01)+.5;
		float y2 = i*.161235+(i*0.01)+.5;
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

vec3 eyeTex(vec2 p)
{
	float r = length( p );
    float a = atan( p.y, p.x );
    float dd = 0.2*sin(0.7*time);
    float ss = 1.0 + clamp(1.0-r,0.0,1.0)*dd;
    r *= ss;
    vec3 col = vec3( 0.0, 0.3, 0.4 );
    float f = fbm( 5.0*p );
    col = mix( col, vec3(0.2,0.5,0.4), f );
    col = mix( col, vec3(0.9,0.6,0.2), 1.0-smoothstep(0.2,0.6,r) );
    a += 0.05*fbm( 20.0*p );
    f = smoothstep( 0.3, 1.0, fbm( vec2(20.0*a,6.0*r) ) );
    col = mix( col, vec3(1.0,1.0,1.0), f );
    f = smoothstep( 0.4, 0.9, fbm( vec2(15.0*a,10.0*r) ) );
    col *= 1.0-0.5*f;
    col *= 1.0-0.25*smoothstep( 0.6,0.8,r );
    //f = 1.0-smoothstep( 0.0, 0.6, length2( mat2(0.6,0.8,-0.8,0.6)*(p-vec2(0.3,0.5) )*vec2(1.0,2.0)) );
    col += vec3(1.0,0.9,0.9)*f*0.985;
    col *= vec3(0.8+0.2*cos(r*a));
    f = 1.0-smoothstep( 0.2, 0.25, r );
    col = mix( col, vec3(0.0), f );
    f = smoothstep( 0.79, 0.82, r );
    return mix( col, vec3(0.9), f );
}

vec3 colorPlane(vec3 ro, vec3 rd, float t)
{ 
	vec3 pos = ro + t*rd;	
		
	float dif = length(pos.xz-sph1.xz);
	float oblique = pow(-dot(rd, vec3(0.0, 1.0, 0.0)), 1.0)+0.7;
	float checker = checkerTex(vec2(pos.x, pos.z), 4.0, 20.0);

	checker = mix(0.3, checker, oblique);
	
	return vec3(1.0)*dif*checker;	
}

vec3 skyColor(vec3 rd)
{
	return mix(vec3(0.9, 0.9, 1.0), vec3(0.0, 0.0, 0.5), rd.y);
}

vec3 colorEye(vec3 ro, vec3 rd, float t, vec4 sph)
{
	vec3 pos = ro + t*rd;
	vec3 n = nSphere( pos, sph );
	
	float refT;
	float refID = intersect(pos, n, refT);
	
	vec3 refCol = vec3(0.0);
	if(refID>1.5)
		refCol = colorPlane(pos, n, refT);
	else 
		refCol = skyColor(n);
	
	float fresnel = clamp(pow(1.0+dot(rd, n), 3.5), 0.1, 0.8);

	vec2 eyeUV = (pos.xy-sph.xy)*1.6;

	vec3 difCol = eyeTex(eyeUV-vec2(mouse.x-0.5, mouse.y-0.5)*1.5);
	return vec3(fresnel*clamp(refCol, 0.0, 1.0)+difCol);
	return difCol+refCol*fresnel;	
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
		col = colorEye(ro, rd, t, sph1);
	else if(id>1.5 && id< 2.5)
		col = colorEye(ro, rd, t, sph2);
	else if(id>2.5)								// Hit plane
		col = colorPlane(ro, rd, t);
	else
		col = skyColor(rd);
	
	gl_FragColor = vec4( col, 1.0 );

}