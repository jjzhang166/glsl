#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float sphereint(vec3 origin, vec3 dir, float r) {
	return .0;
}

mat2 rotate2d(float r) {
	return mat2(cos(r), -sin(r), sin(r),  cos(r));
}

mat3 rotz(float r) {
	return mat3(cos(r), -sin(r), 0.0, 
		    sin(r),  cos(r), 0.0, 
		    0.0, 0.0, 1.0);
}

mat3 roty(float r) {
	return mat3(cos(r), 0.0, sin(r),
		    0.0,    1.0, 0.0,
		    -sin(r), 0.0, cos(r));
}

mat3 rotx(float r) {
	return mat3(1.0, 0.0, 0.0,
		    0.0, cos(r), -sin(r),
		    0.0, sin(r),  cos(r));
}

vec4 infint() {	
	return vec4(0,0,999999.0,0);
}

vec4 planeint(vec3 rayorigin, vec3 dir, vec3 N, float d) {
	// N.( O + tD ) + d = 0
	// N.O + t( N.D ) + d = 0
	// t = -( N.O + d ) / ( N.D )
	float z = dot(N, -rayorigin) / dot(N, dir);
	z -= d;
	
	if (z > 0.0) {
		vec3 hp = rayorigin + dir*z;
		float u = hp.x;
		float v = hp.y;
		if ( u>-10.0 && u<10.0 && v>-10.0 && v<10.0 ) {		
			u = mod(u*1.0, 1.0);
			v = mod(v*1.0, 1.0);
			return vec4(u,v,z,0.0);
		}
	}
	
	
	return infint();
}

vec4 cubeint(vec3 rayorigin, vec3 dir, vec3 center, vec3 siz) {
	vec3 bmin = center - siz;
	vec3 bmax = center + siz;
	vec3 tmin, tmax;
	
	if (dir.x >= 0.0) {
		tmin.x = (bmin.x - rayorigin.x) / dir.x;
		tmax.x = (bmax.x - rayorigin.x) / dir.x;
	} else {
		tmin.x = (bmax.x - rayorigin.x) / dir.x;
		tmax.x = (bmin.x - rayorigin.x) / dir.x;
	}
	if (dir.y >= 0.0) {
		tmin.y = (bmin.y - rayorigin.y) / dir.y;
		tmax.y = (bmax.y - rayorigin.y) / dir.y;
	} else {
		tmin.y = (bmax.y - rayorigin.y) / dir.y;
		tmax.y = (bmin.y - rayorigin.y) / dir.y;
	}

	if (tmin.x > tmax.y)
		return infint();
	
	if (tmin.y > tmax.x)
		return infint();

	if (tmin.y > tmin.x)
		tmin.x = tmin.z;
	if (tmax.y < tmax.x)
		tmax.x = tmax.y;

	if (dir.z >= 0.0) {
		tmin.z = (bmin.z - rayorigin.z) / dir.z;
		tmax.z = (bmax.z - rayorigin.z) / dir.z;
	} else {
		tmin.z = (bmax.z - rayorigin.z) / dir.z;
		tmax.z = (bmin.z - rayorigin.z) / dir.z;
	}

	
	
	
	return infint();
}
	
void main( void ) {
	
	vec3 position = ( vec3(gl_FragCoord.xy, 0.0) / resolution.x ) + vec3(-0.5, -0.5, 0.0);
	float time2 = time;// + 1.0 * position.x - 1.0 * position.y;
	
	mat3 rot =  roty(time2 / 2.0 ) * rotz(time2 / 1.3);// + rotx(time / 3.05);
	
	vec3 ro = vec3(0,4,-10);
	vec3 rd = vec3(position.x/5.0, position.y/5.0, 0.5);
	ro = rot * ro;
	rd = rot * rd;
	
	vec4 t1 = planeint(ro, rd, vec3(0,0,-1), -3.0);
	vec4 t2 = infint();// cubeint(ro, rd, vec3(0,0,0), vec3(0.3,0.2,0.5));
	
	if (t1.z < t2.z && t1.z < 100.0) {
		gl_FragColor = vec4(t1.x, t1.y, 0, 1.0) * 0.44;
	}
	else if (t2.z < 100.0) {
		gl_FragColor = vec4(t2.x, t2.y, 1, 1.0) * 0.44;
	}
	else {
		gl_FragColor = vec4(0.6, 0.6, 0.6, 1.0);
	}
	
}