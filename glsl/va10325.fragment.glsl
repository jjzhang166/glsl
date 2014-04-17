#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float sphere(vec3 centre, float rayon, vec3 depuis) {
	return distance(depuis, centre) - rayon;
}

float dist(vec3 depuis) {
	return min(
		sphere(vec3(mouse.y), 0.5, depuis),
		sphere(vec3(mouse.x), 1.0, depuis)
	);
}

vec3 normale(vec3 point) {
	float e = 0.00001;
	return normalize(
		vec3(
		dist(point + vec3(e, 0.0, 0.0)) - dist(point - vec3(e, 0.0, 0.0)),
		dist(point + vec3(0.0, e, 0.0)) - dist(point - vec3(0.0, e, 0.0)),
		dist(point + vec3(0.0, 0.0, e)) - dist(point - vec3(0.0, 0.0, e))
		));
}

float rayonTouche(vec3 depuis) {
	vec3 oeil = vec3(0.0, 0.0, -5.0);
	vec3 rayon = normalize(depuis - oeil);
	vec3 pointActuel = depuis;
	
	vec3 lumiere = vec3(-1.0, 1.0, -3.0);
	
	
	for (int i = 0 ; i < 20 ; i++) {
		float d = dist(pointActuel);
		if (d < 0.01) {
			vec3 rayonLumiere = normalize(lumiere - pointActuel);
			vec3 n = normale(pointActuel);
			return dot(rayonLumiere, n);
		}
		pointActuel += rayon * d;
	}
	return (0.0);
}

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	position = 2.0 * position - 1.0;
	float d = rayonTouche(vec3(position, -4.0));
	gl_FragColor = vec4( vec3( d ), 1.0 );
}