#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// Fake DOF spheres by Kabuto
// Move mouse vertically to control focal plane
// gngbng remix
//
// Random junk added by @hektor41 v.1

void main( void ) {

	vec3 pos = vec3(0,0,-10);
	vec3 dir = normalize(vec3((gl_FragCoord.xy - resolution.xy*.5) / resolution.x, 1.));

	vec3 color = vec3(.0,.1,.0) * gl_FragCoord.y / resolution.y;
	for (float y = 5.; y >= -5.; y--) {
		for (float x = -5.; x <= 5.; x++) {
			// 
			vec3 s = vec3(x+asin(time+y*.7),tan(acos(cos(time+x)*.5+y*.5)),y+sin(time-x*.7));
			float t = dot(s-pos,dir);
			vec3 diff = (pos+t*dir-s)*3.;
			float dist = length(diff);
			// fake depth of field
			float dof = abs(1./(pos.z-s.z)-mouse.y*.2+.2)*2.;
			float dofdist = (length(diff)-1.)/dof;
			dofdist = max(-1.,min(1.,dofdist));
			dofdist = sign(dofdist)*(1.-pow(1.-abs(dofdist),1.5));
			float invalpha = dofdist*.5+.5;
			color = color*invalpha*0.995 + vec3(.1,.2,.3)*pow(dist,3.)
				* dot(normalize(diff+vec3(0,100.0,2)),vec3(1))*(1.-invalpha);
			color*=vec3(1,1.00001,sin(time*color.x*color.y));
		}
	}
	
	
	
	gl_FragColor = vec4(vec3(color*10.0*sin(time/1000.0)), 1.0 );
	
}