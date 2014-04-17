#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float iSphere(in vec3 ro, in vec3 rd, in vec4 sph) {
	// equation d'un cercle centré à l'origine :
	// |xyz| = r
	// <=> |xyz|^2 = r^2
	// <=> <xyz,xyz> = r^2
	// xyz = ro + t*rd
	// <=> <ro,ro> + 2*t*<ro,rd> + t^2*<rd,rd> = r^2
	// <=> a*t^2 + b*t + c = 0
	// a = <rd,rd> = 1.0
	// b = 2 * <ro,rd>
	// c = <ro,ro> - r^2
	vec3 oc = ro - sph.xyz;
	float a = 1.0;
	float b = 2.0 * dot(oc, rd);
	float c = dot(oc, oc) - sph.w*sph.w;
	float h = b*b - 4.0 * a * c;
	if ( h < 0.0 ) return -1.0;
	
	float t = ( -b - sqrt(h))/(2.0*a);
	return t;
}

float iPlane(in vec3 ro, in vec3 rd) {
	// equation d'un plan: y = 0
	// <=> ro.y + t * rd.y = 0
	return (0.0 - ro.y) / rd.y;
}

void main( void ) {
	vec2 uv = ( gl_FragCoord.xy / resolution.xy );
	uv = 2. * uv - 1.;
	uv *= vec2(resolution.x/resolution.y, 1.0);
	
	vec3 ro = vec3(0.0, 3, 10);
	vec3 rd = normalize(vec3(uv, -1.0));
	
	vec4 position = vec4(0, 1, 0, 1);
	position.x = 3. * cos(time * 4.);
	position.z = 3. * sin(time * 4.);
	
	
	vec3 color = vec3(0.0);
	
	float resT = 100000.0;
	
	float tplan = iPlane(ro, rd);
	if (tplan > 0.0 && tplan < resT) {
		color = vec3(.3, .2, .1);
		resT = tplan;
	}
	
	float tsph = iSphere(ro, rd, position);
	if (tsph > 0.0 && tsph < resT) {
		color = vec3(1,0,0) * (tsph / 8.);
		resT = tsph;
	}
	
	tsph = iSphere(ro, rd, vec4(0, 1, 0, 1));
	if (tsph > 0.0 && tsph < resT) {
		color = vec3(0,0,0) * (tsph / 8.);
		resT = tsph;
	}
	
	gl_FragColor = vec4(color, 1.0);
}