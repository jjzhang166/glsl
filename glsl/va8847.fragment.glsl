#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

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
	vec3 light = normalize( vec3(0.57703));
	//uv are the pixel coordinates, from 0 to 1
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	vec2 p = gl_FragCoord.xy/resolution.xy;
	p = -1.0 + 2.0*p;
	p.x *= resolution.x/resolution.y;

	vec3 lookAt = vec3(0.0, 0.0, 0.0);
	vec3 ro = vec3(5.0,1.0,0.0); //camera position
	vec3 front = normalize(lookAt - ro);
	vec3 left = normalize(cross(vec3(0,1,0), front));
	vec3 up = normalize(cross(front, left));
	vec3 rd = normalize(front*1.5 + left*p.x + up*p.y); // rect vector

	// let's move that sphere...
	sph1.x = 0.0*cos(time);
	sph1.z = 0.0*sin(time);
	
	
	//generate a ray with origin ro and direction rd
	//vec3 ro = vec3(-2.0,1.,2.0);
	//vec3 rd = normalize(vec3(-1.5+3.*uv*vec2(resolution.x/resolution.y,1)-.0,-1.0));
	
	//intersect ray with the 3d scene
	float t;
	float id = intersect (ro,rd,t);
	
	//we need to do some lighting
	//and for that we need normals
	
	vec3 col = vec3(0.5);
	
	if (id > 0.5 && id < 1.5){
		//if hit the sphere
		vec3 pos = ro + t*rd;			//hit position
		vec3 nor = nSphere (pos,sph1);	//normal on hit
		float dif = clamp(dot(nor,light),0.0,1.0);		//
		float ao = 0.5 + 0.0*nor.y;		//ambient oclusion
		col = vec3(0.9,0.8,0.6)*dif*ao +  vec3(0.1,0.2,0.4)*ao;

		col.r *= ao; // mess around with sphere colours
	 	col.r -= sin(time) * ao;
	}else if (id > 1.5){
		//we hit the plane
		vec3 pos = ro + t*rd;
		vec3 nor = nPlane (pos);
		float dif = clamp(dot(nor,light), 0.0,1.0);
		float amb = smoothstep( 0.0,2.0*sph1.w,length(pos.xz-sph1.xz));
		col = vec3(amb*0.7);
		
		col.r *= amb; // mess around with sphere colours
	 	//col.r *= sin(time) * amb;
		
	}
	col = sqrt(col);
	
	gl_FragColor = vec4(col,1.0);
	
}