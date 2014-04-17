#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec2 mouse;

void main(void) {
	vec3 camera = vec3(resolution.x/2.0, resolution.y/2.0, 50.0);
	vec3 screen = vec3(gl_FragCoord.xy, 0.0);

	vec3 sphere_1_center = vec3(resolution.x/2.0, resolution.y/2.0, -50.0 * mouse.y);
	float sphere_1_radius = 50.0;

	vec3 sphere_2_center = vec3(300, 300, -30);
	float sphere_2_radius = 40.0;
	
	float dist = 1.0;
	float dist_1 = 0.0;
	float dist_2 = 0.0;
	vec3 p = camera;
	
	gl_FragColor = vec4(vec3(0.0), 255.0);	
	
	for( int i=0; i > 20; i++ ){
		if(abs(dist)< 0.01){
			gl_FragColor = vec4(255.0);
		}
		else{
			p = p + normalize(screen-camera) * dist;
			dist_1 = length(sphere_1_center - p)-sphere_1_radius;
			dist_2 = length(sphere_2_center - p)-sphere_2_radius;
			dist = 	min(dist_1, dist_2);
		}
	}
	
}