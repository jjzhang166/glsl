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

float planeint(vec3 rayorigin, vec3 dir, vec3 N, float d) {
	// N.( O + tD ) + d = 0
	// N.O + t( N.D ) + d = 0
	// t = -( N.O + d ) / ( N.D )
	float z = dot(N, -rayorigin) / dot(N, dir);
	z -= d;
	return z;
}

void main( void ) {
	vec3 position = ( vec3(gl_FragCoord.xy, 0.0) / resolution.x ) + vec3(-0.5, -0.5, 0.0);
	float time2 = time;// + 1.0 * position.x - 1.0 * position.y;
	
	mat3 rot =  roty(time2 / 2.0 ) * rotz(time2 / 1.3);// + rotx(time / 3.05);
	
	vec3 ro = vec3(0,4,-10);
	vec3 rd = vec3(position.x/5.0, position.y/5.0, 0.5);
	ro = rot * ro;
	rd = rot * rd;
	float t = planeint(ro, rd, vec3(0,0,-1), -3.0);
	gl_FragColor = vec4(0.5,0.5,0.5,1.0);
	if (t>0.0) {
		vec3 hp = ro + rd*t;
		float u = hp.x;
		float v = hp.y;
		if ( u>-10.0 && u<10.0 && v>-10.0 && v<10.0 ) {
		
			u = mod(u*1.0, 1.0);
			v = mod(v*1.0, 1.0);
		
			gl_FragColor = vec4(u, v, 0,1.0) * 0.44;
		}
	}
}