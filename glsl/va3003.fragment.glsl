#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec4 Sphere1 = vec4(0, 1, 0, 1);

float iSphere (in vec3 ro, in vec3 rd, vec4 sph ) {
	vec3 pos = ro - sph.xyz;
	float r = 1.0;
	float b = 2.0*dot( pos, rd );
	float c = dot(pos, pos) - sph.w*sph.w;
	float h = b*b - 4.0*c;
	
	if(h< 0.0) return -1.0;
	
	float t = (-b - sqrt(h))/2.0;
	return t;
}

vec3 nSphere( in vec3 p, in vec4 sph ) { return (p - sph.xyz)/sph.w; }
float iPlane (in vec3 ro, in vec3 rd ) { return -ro.y/rd.y; }

vec3 pos, col = vec3(0);

float 	midpoint = 4.5,
	temporal = time/4.0,
	spacing = 3.5,
	dscaler = 2.0;
float intersect( in vec3 ro, in vec3 rd, out float resT )
{
	resT = 1000.0;
	float id = -1.0, tsphere = 1337.;
	
	float tSphere = iSphere( ro, rd, Sphere1 );
	float tPlane = iPlane( ro, rd );
	if(tPlane > 0.0 && tPlane < resT)
	{
		id = 2.0;
		resT =  tPlane;
	}
	
	if (abs(pos.x) < 40.0*(-1.0/rd.y) && abs(pos.z) < 40.0*(-1.0/rd.y))
	{
		vec4 evalSphereVec4;
		float evalSphere;

		for (float x = 0.0; x < 10.0; x++) for (float z = 0.0; z < 10.0; z++){
			evalSphereVec4 = vec4((x-midpoint)*spacing + dscaler*sin(temporal*(x-midpoint)*spacing),1.0+0.5*sin(x-midpoint)*cos(z-midpoint),(z-midpoint)*spacing - dscaler*cos(temporal*(z-midpoint)*spacing),1.0);
			evalSphere = iSphere( ro, rd, evalSphereVec4 );

			if (evalSphere > -1.0 && evalSphere < tsphere)
			{
				tSphere = evalSphere;
				Sphere1 = evalSphereVec4;
				pos = ro + tSphere*rd;
				id = 1.0;
				resT = tSphere;
			}
		}
	}
	return id;
}

float shadow( in vec3 lo, in vec3 ld )
{
	float resT = 1.0;
	float id = -1.0;
	float tsphere = iSphere( lo, ld, Sphere1 );
	float tplane = iPlane( lo, ld );

	if (tsphere > 0.0)
	{
		id = 1.0;
		resT = tsphere;
	}
	if (tplane > 0.0 && tplane < resT)
	{
		id = 2.0;
		resT = tplane;
	}
	return resT;
}
void main( void ) {

	vec3 lightDir = normalize(vec3(1,1,1));
	
	vec2 uv = ((gl_FragCoord.xy) / resolution.xy);
	vec2 aspectRatio = vec2(resolution.x/resolution.y, 1.0);
	
	vec3 ro = vec3( 0.0, 10.0, 40.0);
	vec3 rd = normalize( vec3( (-1.0+2.0*uv)*aspectRatio, -1.0));

	vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
	vec3 rdCam = normalize(vec3(0.414213*(resolution.x/resolution.y)*p.x,0.414213*p.y,-1.0));
	rd = rdCam + vec3(mouse.x - 0.5,-0.25, mouse.y - 0.5);
	rd = normalize(rd);
	
	Sphere1.x = cos(time);
	Sphere1.z = sin(time);
	
	float t;
	float id = intersect( ro, rd, t );

	pos = ro + t*rd;
	vec3 nor;
	
	if(id>0.5 && id<1.5)
	{
		
		nor = nSphere( pos, Sphere1 );
		
		float stdShadow = clamp(dot(nor,lightDir), 0.0, 1.0);
		float ambient = 0.5 + 0.5*nor.y;
		float ao = 0.5 + 0.5*nor.y;

		col = vec3( stdShadow ) + ambient*vec3(0.2,0.3,0.4)*ao;	
		
	}
	else
	{
		float ambient = 0.5 + 0.5*nor.y;
		float stdShadow = clamp(dot(nor,lightDir),0.0,1.0);
		float amb = 1.0;

		for (float x = 0.0; x < 10.0; x+= 1.0) for (float z = 0.0; z < 10.0; z+=1.0 )
		{
			vec4 evalSphereVec4 = vec4((x-midpoint)*spacing + dscaler*sin(temporal*(x-midpoint)*spacing),1.0,(z-midpoint)*spacing - dscaler*cos(temporal*(z-midpoint)*spacing),1.0);
			amb = min(smoothstep( 0.0, 1.5*Sphere1.w, length(pos.xz - evalSphereVec4.xz) ), amb);
		}
		
		vec3 distDropoff = vec3(clamp(vec3(1.0-clamp(pow(length(pos.xz*0.01),2.0),0.0,1.0)),0.0,1.0));

		float shadow1;
		
		for (float x = 0.0; x < 10.0; x+= 1.0) shadow1 += clamp(shadow(pos - 0.0001*vec3(-1.0), -x/2.0*vec3(-1.0)),0.0,1.0);
		shadow1 /= 10.0;
		shadow1 = 1.0;
		col = sqrt(amb*vec3(0.85,0.9,0.95)*distDropoff*vec3(shadow1));
	}
	
	gl_FragColor = vec4( col, 1.0 );

}