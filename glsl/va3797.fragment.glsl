#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// Fake DOF spheres by Kabuto
// Move mouse vertically to control focal plane
// gngbng remix

void main( void ) {

	vec3 pos = vec3(0,0,-10);
	vec3 dir = normalize(vec3((gl_FragCoord.xy - resolution.xy*.5) / resolution.x, 1.));

	vec3 color = vec3(.05,.1,.15) * gl_FragCoord.y / resolution.y;
	for (float y = 5.; y >= -5.; y--) {
		for (float x = -5.; x <= 5.; x++) {
			// 
			vec3 s = vec3(x+sin(time+y*.7),sin(time+x*.5+y*.5),y+sin(time-x*.7));
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
				* dot(normalize(diff+vec3(0,0,2)),vec3(1))*(1.-invalpha);
		}
	}
	
	
	
	gl_FragColor = vec4(vec3(color), 1.0 );

}