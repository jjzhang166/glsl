// Raymarched menger sponge by Kabuto


// Mouse left/right to change level of detail
// Mouse up/down to change camera distance

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;



// This function determines the maximetric distance between a given point and the closest menger sponge point.
float mdist(vec3 p) {
	float x = p.x;
	float y = p.y;
	float z = p.z;
	float mindist = 0.0;
	float f = 1.0;
	for (int i = 0; i < 12; i++) {
		float mx = max(max(abs(x),abs(y)),abs(z));
		mindist = max(mindist, (mx-1.5)*f);
		if (mx >= 2.0) return mindist;
		float mn = min(min(abs(x),abs(y)),abs(z));
		float med = abs(x)+abs(y)+abs(z)-mx-mn;
		float xc = sign(x)*min(floor(abs(x)+0.5),1.0);
		float yc = sign(y)*min(floor(abs(y)+0.5),1.0);
		float zc = sign(z)*min(floor(abs(z)+0.5),1.0);
		
		if (med < 0.5) {
			mindist = max(mindist,(0.5-med)*f);
			if (med < 1.0/3.0) return mindist;
		}
		x = (x-xc)*3.0;
		y = (y-yc)*3.0;
		z = (z-zc)*3.0;
		f /= 3.0;
	}
	return mindist;
}

vec3 march(vec3 pos, vec3 dir, float lod) {
	vec3 p = pos;
	
	// Trick: normalize ray not to the unit sphere but to the unit cube instead (as the cube distance function returns maximetric distance instead of euclidean distance)
	float mx = max(abs(dir.x),max(abs(dir.y),abs(dir.z)));
	dir /= mx;
	
	for (float n = 0.0; n < 1024.0; n += 1.0) {
		float dist = mdist(p);
		if (dist < lod) {
			//return vec3(1.0/(1.0+distance(p,pos)));
			return vec3(1.0-sqrt(sqrt(n/1024.0)));
		}
		if (dist > 10.0) return vec3(0.0,0.0,0.2);
		p += dist*dir;
	}
	return vec3(0.0,0.0,0.0);
}

void main( void ) {

	// fractals ftw
	
	vec3 dir = vec3(cos(time*0.2),0,sin(time*0.2));
	vec3 up = vec3(0,1,0);
	vec3 right = cross(dir, up);
	
	vec3 pos = dir*-(mouse.y*8.0)+vec3(0,0.01,0);//+right*(mouse.x-0.50001)+up*(mouse.y-0.500002);
	vec3 dir2 = normalize(dir+right*(gl_FragCoord.x / resolution.x - 0.5)+up*(gl_FragCoord.y-resolution.y*0.5)/resolution.x);
	
	gl_FragColor = vec4(march(pos, dir2, exp(-11.0+8.0*mouse.x)), 1.0);

}