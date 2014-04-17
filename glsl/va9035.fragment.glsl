#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// A reflecting and refracting sphere, as seen through a polarizer.
// Mouse x: refraction index ratio. Left half of the screen: refraction of sphere smaller than outside (bubble), right half of the screen: refraction of sphere larger (sphere)
// Mouse y: polarization. Top half: use polarization filter in camera, bottom half: don't use. The change occurs suddenly, not gradually as refraction index.

float sq(float a, float b, float c, float d) { return (d*sqrt(b*b-a*c)-b)/a; }

bool sqt(float a, float b, float c) { return b*b >= a*c; }

vec3 envcolor(vec3 dir) {
	float f = abs(dir.x*dir.y*dir.z);
	vec3 result = (dir*.4+.5)*step(abs(fract(f*20.)-.5)+dir.z,-.33)*(.9+.1*sign(fract(atan(dir.z,dir.x)/acos(0.)*4.)-.5)*sign(fract(atan(dir.y/length(dir.xz))/acos(0.)*4.)-.5));
	return result*result;
}

float surfcolor(vec3 pos) {
	float px = fract(atan(pos.x,pos.z)/acos(0.)*16.)-.5;
	float py = pos.y/acos(0.)*16.;
	return step(px*px+py*py,.0625)*.3;
}

struct Refraction {
	vec2 r; // reflection amounts
	vec3 vrefl;	// reflected ray
	vec3 vrefr;	// refracted ray
};

// A mocked-up version of the original refract method, derived from Fresnel's equations
Refraction refract2(vec3 ray, vec3 normal, float ratio) {
	Refraction result;
	
	float nr = dot(normal, ray);
	
	result.vrefl = normalize(ray - 2. * nr * normal);
	
	float k = 1.0 - ratio * ratio * (1.0 - nr*nr);
    	if (k < 0.0) {
        	result.vrefr = ray; // just to be sure it doesn't cause NaN
		result.r = vec2(1.);
    	} else {
        	result.vrefr = normalize(ratio * ray - (ratio * nr + sqrt(k)) * normal);
		float ci = -nr;
		float ct = sqrt(k);
		float rs = (ratio*ci-ct)/(ratio*ci+ct);
		float rt = (ratio*ct-ci)/(ratio*ct+ci);
		result.r = vec2(rs*rs, rt*rt);
	}
	return result;
}

vec3 mainpart(vec3 pos, vec3 dir, float ref, vec2 polmix) {
	// Available fraction of light. This takes polarization into account. (s, p)
	vec2 t = vec2(1.);
	
	// Advance to the sphere's surface
	pos += dir*sq(1.,dot(pos,dir),dot(pos,pos)-1.,-1.);

	vec3 color = vec3(0);
	
	// Surface texture
	color += surfcolor(pos)*dot(t,polmix);
	
	Refraction a;

	a = refract2(dir, pos, 1./ref);
	color += envcolor(a.vrefl)*dot(t*a.r,polmix);
	t *= 1.-a.r;
	dir = a.vrefr;
	
	// Up to 4 internal reflections
	for (int i = 0; i < 16; i++) {
		// Advance ray to other side of sphere
		pos += dir*sq(1.,dot(pos,dir),dot(pos,pos)-1.,1.);
		
		color += surfcolor(pos)*dot(t,polmix);
		
		a = refract2(dir, -pos, ref);
		color += envcolor(a.vrefr)*dot(t*(1.-a.r),polmix);
		t *= a.r;
		dir = a.vrefl;
	}
	
	return color;
}


float r2r(float ref) {
	float aref = 1.+sqrt(1.+ref*ref);
	return (aref+ref)/(aref-ref);
}

void main( void ) {
	// All code by Kabuto
	
	float ref = tan(1.57*(2.*mouse.x-1.));
	
	//vec3 pos = vec3(( gl_FragCoord.xy*2. - resolution.xy ) / resolution.y, -2.);
	//vec3 dir = vec3(0,0,1);

	vec3 pos = vec3(0,0,-2.3);
	vec3 dir = normalize(vec3(( gl_FragCoord.xy*2. - resolution.xy ) / resolution.y, 2.));
	
	float scanline = mod(gl_FragCoord.y,2.);
	
	float c = dir.x*dir.x/dot(dir.xy,dir.xy);
	float my = step(mouse.y,.5);
	vec2 polmix = vec2(1.-c,c)*(1.-my)+.5*my;

	mat3 mat = mat3(cos(time),0,sin(time),0,1,0,-sin(time),0,cos(time));
	float b = -.2;
	mat = mat3(1,0,0,0,cos(b),sin(b),0,-sin(b),cos(b))*mat;
	pos *= mat;
	dir *= mat;
	
	// Discard rays missing the sphere
	if (!sqt(1.,dot(pos,dir),dot(pos,pos)-1.)) {
		gl_FragColor = vec4(sqrt(envcolor(dir)),1.);
	} else {
		vec3 color = vec3(0);
		float n = fract(dot(fract(dir*1e4),vec3(20,30,40)));
		const int jt = 4;
		for (int j = 0; j < jt; j++) {
			float j2 = (float(j)+n)/float(jt)*2.-1.;
			color += mainpart(pos,dir, r2r(ref*(1.+j2*.05)), polmix) * max(vec3(0.),1.-abs(vec3(-1.,0.,1.)-j2*2.));
		}
		gl_FragColor = vec4( sqrt(color), 1.0 );
	}
}