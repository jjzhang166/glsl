#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;

void main(void) {
	// the gear
	vec3 camera = vec3(resolution.x * 0.5, resolution.y * 0.5, 50.0);
	vec3 screen = vec3(gl_FragCoord.xy, 0.0);
	vec3 light = vec3(700.0, 700.0, 50.0);
	
	// sphere 1 (white)
	vec3 sphere_1_center = vec3(500.0, 500.0, -50.0 + cos(time)* 30.0);
	float sphere_1_radius = 30.0;
	vec4 sphere_1_color = vec4(0.0, 0.5, 1.0, 1.0);

	// sphere 2 (red)
	vec3 sphere_2_center = vec3(400.0 + 100.0 * sin(time), 400.0 + 100.0 * sin(time), -80.0);
	float sphere_2_radius = 70.0;
	vec4 sphere_2_color = vec4(1.0, 0.0, 0.0, 255.0);
	
	float dist;
	float dist_1;
	float dist_2;
	
	vec3 p = camera;
	
	vec3 p_normal;
	vec3 p_light;
	float light_angle;
	
	vec4 color = vec4(0.2);
	gl_FragColor = color;
	
	//the direction for the point p to travel along 
	vec3 ray_direction = normalize(screen-camera);
	
	// march a max of 100 steps along the ray
	for( int i=0; i < 100; i++ ){
		// calculate the distance to the spheres
		dist_1 = length(sphere_1_center - p) - sphere_1_radius;
		dist_2 = length(sphere_2_center - p) - sphere_2_radius;

		// select the minimum and choos color
		if(dist_1 < dist_2){
			dist = dist_1;
			// calc sphere surface normal vector
			p_normal = normalize(p - sphere_1_center);
			
			// calc vector pointoing towards the light
			p_light = normalize(light - p);
			
			// calc cos of the angle between the surface normal and light vector ([0,1])
			light_angle = dot(p_normal, p_light);
			
			// calculate diffuse lighting color by multiplying the orginial color
			// with the cos() of the angle between normal and light source
			// ths shading it
			color = vec4(sphere_1_color.rgb * light_angle, sphere_1_color.a);
		}
		else{
			dist = dist_2;
			p_normal = normalize(p - sphere_2_center);
			p_light = normalize(light - p);
			light_angle = dot(p_normal, p_light);
			color = vec4(sphere_2_color.rgb * light_angle, sphere_2_color.a);
		}
		
		// move point along the ray
		p = p + ray_direction * dist;

		// if distance to surface is small, color pixel
		if(abs(dist) < 0.01){	
			gl_FragColor = color;
			break;
		}
	}
	
}
