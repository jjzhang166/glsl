#ifdef GL_ES
precision mediump float;
#endif

/*
	@geofftnz

	forking someone's raytraced sphere in order to do some material testing.

	Trying to make something roughly like snow.
*/

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float rand(vec3 co){
    return fract(sin(dot(co.xyz ,vec3(12.9898,78.233,47.985))) * 43758.5453);
}

// credit: iq/rgba
float hash( float n )
{
    return fract(sin(n)*43758.5453);
}


// credit: iq/rgba
float noise( in vec3 x )
{
    vec3 p = floor(x);
    vec3 f = fract(x);
    f = f*f*(3.0-2.0*f);
    float n = p.x + p.y*57.0 + 113.0*p.z;
    float res = mix(mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),
                        mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y),
                    mix(mix( hash(n+113.0), hash(n+114.0),f.x),
                        mix( hash(n+170.0), hash(n+171.0),f.x),f.y),f.z);
    return res;
}

vec3 skycol(vec3 d)
{
	// start with blue
	vec3 c = vec3(0.02,0.03,0.1);
	
	if (d.y>0.0){
	c += vec3(0.0,0.2,0.35) * (1.0 - pow(clamp(dot(d,vec3(0.0,1.0,0.0)),0.0,1.0),1.0/3.0));
	c += vec3(0.3,0.32,0.35) * (1.0 - pow(clamp(dot(d,vec3(0.0,1.0,0.0)),0.0,1.0),1.0/4.0));
	}
	c += vec3(0.3,0.32,0.35) * (pow(clamp(dot(d,vec3(0.0,-1.0,0.0)),0.0,1.0),1.0/4.0));
	
	return c;
}


float iSphere (in vec3 ro, in vec3 rd, in vec4 sph){
	//a sphere centered at the origin has eq: |xyz| = r
	//meaning, |xyz|^2 = r^2, meaning <xyz,xyz> = r^2
	// now, xyz = ro + t*rd, therefore |ro|^2 + t^2 + 2<ro,rd>t - r^2 = 0
	// which is a quadratig equation. so
	float r = sph.w; //radius
	vec3 oc = ro - sph.xyz; //origin = position sphere
	float b = 2.0*dot(oc,rd);
	float c = dot(oc,oc)-r*r;
	float h = b*b - 4.0*c;
	if (h <0.0) return -1.0;
	float t = (-b - sqrt(h))/2.0;
	return t;
}

vec3 nSphere (in vec3 pos, in vec4 sph){
	return (pos - sph.xyz) / sph.w;
}

float iPlane(in vec3 ro, in vec3 rd){
	//eq. of a plane, y=0 = ro.y + t*rd.y
	return -ro.y/rd.y;
}

vec3 nPlane( in vec3 pos){
	return vec3(0.0,1.0,0.0);
}

vec4 sph1 = vec4 (0.0,1.0,0.0,1.0);

float intersect( in vec3 ro, in vec3 rd, out float resT){
	resT = 1000.0;
	float id = -1.0;
	float tsph = iSphere (ro, rd, sph1); //intersect with sphere
	float tpla = iPlane (ro,rd); //intersect with plane
	if (tsph > 0.0){
		id = 1.0;
		resT = tsph;
	}
	if (tpla > 0.0 && tpla < resT){
		id = 2.0;
		resT = tpla;
	}
	return id;
}

void main(void)
{
	vec3 light = normalize( vec3(0.5,1.0,0.5));
	vec3 lightcol = vec3(1.0,0.4,0.2)*2.0;
	vec3 ambcol = vec3(0.05,0.07,0.12)*5.0;
	//vec3 groundcol = lightcol;//vec3(0.9,0.92,1.3) * 0.5;
	vec3 difcol = vec3(0.85);
	//uv are the pixel coordinates, from 0 to 1
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	vec2 p = gl_FragCoord.xy/resolution.xy;
	p = -1.0 + 2.0*p;
	p.x *= resolution.x/resolution.y;

	vec3 lookAt = vec3(0.0, 0.9, 0.0);
	vec3 ro = vec3(3.0,1.5,0.0); //camera position
	vec3 front = normalize(lookAt - ro);
	vec3 left = normalize(cross(vec3(0,1,0), front));
	vec3 up = normalize(cross(front, left));
	vec3 rd = normalize(front*1.5 + left*p.x + up*p.y); // rect vector

	// let's move that sphere...
	//sph1.x = (mouse.y-0.5)*5.0;//0.0*cos(time);
	//sph1.z = (mouse.x-0.5)*10.0;//0.0*sin(time);
	
	light.x = (0.8-mouse.y)*5.0;
	light.z = (mouse.x-0.5)*5.0;
	light = normalize(light);
	
	vec3 groundcol = (lightcol + ambcol) * 0.3;// * clamp(dot(vec3(0.0,1.0,0.0),light),0.0,1.0);
	
	
	//generate a ray with origin ro and direction rd
	//vec3 ro = vec3(-2.0,1.,2.0);
	//vec3 rd = normalize(vec3(-1.5+3.*uv*vec2(resolution.x/resolution.y,1)-.0,-1.0));
	
	//intersect ray with the 3d scene
	float t;
	float id = intersect (ro,rd,t);
	
	// half vector between view ray and light ray
	//vec3 halfvec = normalize(-rd+light);
	
	//we need to do some lighting
	//and for that we need normals
	
	vec3 col = vec3(0.5);
	
	if (id > 0.5 && id < 1.5){
		//if hit the sphere
		
		
		vec3 pos = ro + t*rd;			//hit position
		vec3 nor = nSphere (pos,sph1);	//normal on hit

		vec3 p3 = (pos-sph1.xyz)*157.0;
		vec3 nor3 = normalize((vec3(noise(p3),noise(p3*6.7),noise(p3*3.1))-vec3(0.5)));
		
		nor = normalize(nor + nor3 * 0.02);
		
		//difcol = pos;
		//difcol = normalize(vec3(rand(pos),rand(pos*1.5),rand(pos*7.1)));
		
		float dif = clamp(dot(nor,light),0.0,1.0);		// diffuse
		

		// facets
		vec3 refl = reflect(rd,nor);
		vec3 spec = lightcol * pow(clamp(dot(light,refl),0.0,1.0),2.0) * 0.1;
		
		vec3 totalspec = vec3(0.0);
		vec3 totaldif = vec3(0.0);
		
		for(float i=0.0;i<10.0;i+=1.0){
			vec3 p2 = (pos-sph1.xyz)*100.0 + vec3(i*19.3);
			vec3 nor2 = normalize((vec3(noise(p2),noise(p2*1.5),noise(p2*7.1))-vec3(0.5)));
			float facetintensity = 0.1 + rand(p2);
			
			//float fre = pow( clamp(1.0+dot(nor2,rd),0.0,1.0), 2.0 );
			
			vec3 refl = reflect(rd,nor2);	
			totaldif += skycol(refl);
			totalspec += pow(clamp(dot(light,refl),0.0,1.0),200.0) * (clamp(dot(nor,light)+0.1,0.0,1.0)) * facetintensity;// * fre;
		}
		
		//spec += totalspec * sqrt(dif) * 0.2;
		
		//float spec = pow(clamp(dot(nor,halfvec),0.0,1.0),30.0);
		
		//float fre = pow( clamp(1.0+dot(nor,rd),0.0,1.0), 2.0 );
		//vec3 refcol = skycol(refl) * fre;
		
		float ao = 0.8 + nor.y*0.5;		//ambient oclusion
		float groundamb = pow(clamp(dot(nor, vec3(0.0,-1.0,0.0)),0.0,1.0),2.0); //clamp(-nor.y,0.0,1.0);
		
		col = lightcol*difcol*dif + totaldif * 0.01 +  totalspec + spec + /*+ refcol*/ +  difcol*ambcol*ao + groundcol * groundamb;
		//col.r *= ao; // mess around with sphere colours
	 	//col.r -= sin(time) * ao;
	}/*else if (id > 1.5){
		//we hit the plane
		vec3 pos = ro + t*rd;
		vec3 nor = nPlane (pos);
		float dif = clamp(dot(nor,light), 0.0,1.0);
		float amb = smoothstep( 0.0,2.0*sph1.w,length(pos.xz-sph1.xz));
		col = vec3(amb*0.7);
		
		//col.r *= amb; // mess around with sphere colours
	 	//col.r *= sin(time) * amb;
		
	}*/else{
		col = skycol(rd);
	}
	
	// reinhardt
	//col /= (col + 1.0);
	float whitelevel = 2.0;
	col = (col  * (vec3(1.0) + (col / (whitelevel * whitelevel))  ) ) / (vec3(1.0) + col);	
	
	col = pow(col,vec3(1.0/2.2));
	
	gl_FragColor = vec4(col,1.0);
	
}