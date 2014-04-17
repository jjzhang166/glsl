#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


// Simple spheretracer by Kabuto (or what was left thereof in my brain wafter my f***ing Radeon 4850 overheated, crashing my PC... is it really that difficult to throttle, AMD?)

// Spheretracing basically starts by placing a sphere at the center of the coordinate system, and then repeatedly increasing the number of spheres by mirroring the spheres across an arbitrarily defined plane.
// Of course the number isn't really always doubled since spheres can also get lost if they were on the wrong side of the mirroring plane (since it mirrors one side onto the other one and overwrites what was left there before).

// A huge advantage of this process is that it's very easy to raymarch the result. The distance formula never gets a value that's too high.

float spheretrace(vec3 pos) {
	float scale = 1.;
	float angle = time*.3;
	float mx = (mouse.x-.5)*6.28;
	float my = (mouse.y-.5)*3.14;
	vec3 axis0 = vec3(cos(mx)*cos(my),sin(my),sin(mx)*cos(my));

	// Compute rotation matrix (faster than multiplying with quaternions)
	float c0 = cos(angle);
	float s0 = sin(angle);
	vec3 as = axis0*s0;
	vec3 ac = axis0*axis0*(1.-c0);
	vec3 ad = axis0.yzx*axis0.zxy*(1.-c0);
	mat3 rot = mat3(
		c0   + ac.x , ad.z - as.z , ad.y + as.y,
		ad.z + as.z , c0   + ac.y , ad.x - as.x,
		ad.y - as.y , ad.x + as.x , c0   + ac.z
	)*1.26;
			 
	for (int i = 0; i < 30; i++) {
		// actual rotation
		pos *= rot;
		
		// space mirroring and scaling
		pos.z = abs(pos.z)-4.*1.26;
		scale *= 1.26;
	}
	return (length(pos)-2.)/scale;
}





void main( void ) {
	vec3 pos = vec3(0,0,-30);
	vec3 dir = normalize(vec3((gl_FragCoord.xy-resolution*.5)/resolution.x,1));
	
	// This is a kind of fake occlusion mapping. The more steps we need to take until we hit a surface, the more occluded space must be, the darker we can colorize the target.
	vec3 color;
	
	// Raymarch
	for (int iter = 0; iter < 32; iter++) {
		float dist = spheretrace(pos);
		pos += dist*dir;
		color += vec3(1./(1.+dist),1./(1.+dist*dist),1./(1.+dist*dist*dist))*dist;
	}

	gl_FragColor = vec4( vec3( 1./color/(1.+spheretrace(pos)) ), 1.0 );

}