// forked from https://www.shadertoy.com/view/XdfGzN
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//messing up distance functions 
//s

vec2 screen_space_coords = (gl_FragCoord.xy / resolution.xy) * 2.0 - 1.0;
float aspect_ratio = resolution.x / resolution.y;
	
vec3 ambient_light 	= vec3(0.15, 0.15, 0.21);
vec3 camera_location 	= vec3(0.0, 0.0, -5.0);

vec3 light_direction0 	= normalize(vec3(0.2, 0.45, .7));
vec3 light_direction1 	= normalize(vec3(0.9, 0.1, -.15));

vec3 fog;
vec3 intersect;

float zoom 			= 1.0;
float perspective 		= 0.5;
float march_step 		= 1.0;
float minimum_distance 		= 1.0;
float camera_distance 		= length(camera_location);
float shadow_bias 		= 10.0;
float shadow_penumbra_factor 	= 256.0;

float n;

mat2 rot90 = mat2( vec2(0, -1), vec2(1, 0));

vec3 colors(vec2 uv){
 	vec3 c;
	float cs = .5*atan(uv.x, uv.y);
	c.r = cos(cs-1.);
	c.g = sin(cs-1.6);
	c.b = cos(cs+1.);
	return c;
}

float generateHeight(vec2 pos){
	//return sin(length(pos-vec2(0.5,0.5))*100.0+time*4.0)*sin(length(pos-vec2(0.0,0.5))*100.0+time*4.0);
	//return sin(pos.x*100.0)+sin(pos.y*100.0);
	//return 1.0;
	float r = sin(pos.x*pos.y*100.*cos(pos.x*77.77)*time)*cos(tan(log(pos.x)+pos.y/time))/fract(tan(pos.x*pos.x*pos.y)*(time)*100.);
	return sin(r+time);
}

vec3 generateNormal(vec2 pos){
	float x = pos.x;
	float y = pos.y;
	
	vec3 lH = vec3( 1.0, 0.0, generateHeight(pos + vec2(1.0/resolution.x,0.0) ) );
	vec3 uH = vec3( 0.0, 1.0, generateHeight(pos + vec2(0.0,1.0/resolution.y) ) );
	//vec3 rH = vec3( -1.0, 0.0, generateHeight(pos + vec2(-1.0,0.0) ) );
	//vec3 dH = vec3( 0.0, -1.0, generateHeight(pos + vec2(0.0,-1.0) ) );
	vec3 H = vec3( 0.0, 0.0, generateHeight(pos));
	
	vec3 normal = cross( lH - H, uH - H);
	
	//vec3 normal = uH-H;
	return normalize(normal);
}


float hash(vec2 co)
{
	return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float noise(vec2 p, float s){
	return fract(956.9*cos(429.9*dot(vec3(p,s),vec3(9.7,7.5,11.3))));
}
 
float mix2(float a2, float b2, float t2)
{
	return mix(a2,b2,t2*t2*(3.-2.*t2)); 
}
	
float fractnoise(vec2 p, float s, float c){
	float sum = .0;
	for(float i=0. ;i<3.; i+=1.){
        
		vec2 pi = vec2(pow(2.,i+c));
		vec2 posPi = p*pi;
		vec2 fp = fract(posPi);
		vec2 ip = floor(posPi);
	
		float n0 = noise(ip, s);
		float n1 = noise(ip+vec2(1.,.0), s);
		float n3 = noise(ip+vec2(.0,1.), s);
		float n4 = noise(ip+vec2(1.,1.), s);
		
		float m0 = mix2(n0,n1, fp.x);	
		float m1 = mix2(n3,n4, fp.x);
		float m3 = mix2(m0, m1, fp.y);
		
        	sum +=abs(2.0*pow(.5,i+c)*m3);
	}
	
	return sum*(2.2-c);
}

float cube(vec3 v, vec3 size, vec3 position) {
	vec3 distance = abs(v + position) - size;
	vec3 distance_clamped = max(distance, 0.0);
	return length(distance_clamped) - 0.05;
}

float sphere(vec3 v, float radius, vec3 position) {
	return length(v + position) - radius;
}

float scene(vec3 v) {
	float distance = camera_distance;
	
	vec2 p = vec2(time + v.x * .2, v.z * .11)+v.y*.4;
	
	n = fractnoise(p, .775, 1.2); //lulzslow
	
	vec3 w = vec3(2., sin(time+p.x)+n*sin(time+p.y), 0.)-p.y;
	float s = cos(.2);
	float c1 = cube(v+n+w , vec3(64., .1+n+s, 2048.), vec3(0., 5., 0.));
	
	fog = c1 * v;
	
	distance = c1;
	
	return distance;
}

mat3 axis_x_rotation_matrix(float angle) {
	return mat3(1.0, 0.0, 0.0,
		    0.0, cos(angle), -sin(angle),
		    0.0, sin(angle), cos(angle));
}

mat3 axis_y_rotation_matrix(float angle) {
	return mat3(cos(angle), 0.0, sin(angle),
		    0.0, 1.0, 0.0,
		    -sin(angle), 0.0, cos(angle));
}

vec3 raymarch(vec3 ray, vec3 view_direction, float cube_size) {
	
	
	vec3 uv = vec3(screen_space_coords, screen_space_coords);
	
	vec3 output_color = -.95+vec3(uv.y+.6, uv.y+.1, uv.y);
	float distance = minimum_distance * 2.0;
	
	for (int iteration = 0; iteration < 32; ++iteration) {
		distance = scene(ray);
		if (distance < minimum_distance) {
			break;
		}
		ray += view_direction * march_step * distance;
	}
	
	if (distance < minimum_distance) {
		
		vec3 epsilon = vec3(0.1, 0.0, 0.0);
		
		vec3 normal = normalize(vec3(
			scene(ray + epsilon.xyy) - scene(ray - epsilon.xyy),
			scene(ray + epsilon.yxy) - scene(ray - epsilon.yxy),
			scene(ray + epsilon.yyx) - scene(ray - epsilon.yyx)
		));
		
		float shadow_value = 1.;
	
		ray += light_direction0 * march_step * shadow_bias;
		for (int iteration = 0; iteration < 32; ++iteration) {
			distance = scene(ray);
			if (distance < minimum_distance) {
				shadow_value = 0.3;
				break;
			}
			shadow_value = min( shadow_value, shadow_penumbra_factor * distance / float(iteration) );
			ray += light_direction0 * march_step * distance;
		}
		
		float light_contribution0 		= max(0.0, dot(normal, light_direction0));
		float specular_light_contribution0 	= pow(max(0.0, dot(reflect(view_direction, normal), light_direction0)), 64.0);
		
		float light_contribution1 		= max(0.0, dot(normal, light_direction1));
		float specular_light_contribution1 	= pow(max(0.0, dot(reflect(view_direction, normal), light_direction1)), 64.0);
		
		vec3 light0 = .04 + vec3(0.3, 0.2, 0.1) * light_contribution0 + specular_light_contribution0;
		vec3 light1 = .09 + vec3(0.1, 0.1, 0.2) * light_contribution1 + specular_light_contribution1;
		
		
		vec3 color0 = light0 * shadow_value + ambient_light + length(normalize(fog*uv));
		vec3 color1 = light1 * abs(cos(.001 * distance * normal)) * 1.14;
		
		output_color = light0 * color0 + light1 * color1 - (uv.y * .24 + uv.y) + .15 *  -length(vec2(uv.x, uv.y));
		
		output_color += .3 * output_color * colors(vec2(normal.xy+distance));
	}
	
	return output_color;
}

void main(void) {
	screen_space_coords.x *= aspect_ratio;
	screen_space_coords.xy /= zoom;
	
	vec2 screen_space_mouse_coords = (mouse.xy * 2.0 - 1.0) * 2.0;
	screen_space_mouse_coords.x *= aspect_ratio;
	screen_space_mouse_coords.y = -screen_space_mouse_coords.y;
	vec3 ray = vec3(screen_space_coords.xy, 0.0) + camera_location;
	
	mat3 rotation = axis_y_rotation_matrix(.1*screen_space_mouse_coords.x);
	rotation *= axis_x_rotation_matrix(.1*screen_space_mouse_coords.y);
	vec3 view_direction = normalize(vec3(screen_space_coords.x * perspective, screen_space_coords.y * perspective, 1.0));
	light_direction0 *= rotation;
	ray *= rotation;
	view_direction *= rotation;
	
	vec3 light_contribution = raymarch(ray, view_direction, 0.5);
	
	vec3 color = vec3(.36, .73, .92);
	
	vec3 output_color = .25 * color + color * light_contribution;
	
	output_color = pow(output_color, vec3(1.6, 1.9, 1.6));
	
    	gl_FragColor = vec4(output_color, 1.0);
}