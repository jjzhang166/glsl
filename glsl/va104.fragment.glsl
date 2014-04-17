#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float eps = 0.005;

const float height_scale = 1.0;

vec3 camera = vec3(0.5,1.5,0.3 * time);

vec3 mod289(vec3 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec2 mod289(vec2 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec3 permute(vec3 x) {
  return mod289(((x*34.0)+1.0)*x);
}

float snoise(vec2 v)
  {  const vec4 C = vec4(0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439); 
  vec2 i  = floor(v + dot(v, C.yy) );  vec2 x0 = v -   i + dot(i, C.xx);
  vec2 i1;  i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);  vec4 x12 = x0.xyxy + C.xxzz;
  x12.xy -= i1;
  i = mod289(i);  vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 )) + i.x + vec3(0.0, i1.x, 1.0 ));
  vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);  m = m*m ;  m = m*m ;
  vec3 x = 2.0 * fract(p * C.www) - 1.0;  vec3 h = abs(x) - 0.5;  vec3 ox = floor(x + 0.5);  vec3 a0 = x - ox;
  m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );
  vec3 g;  g.x  = a0.x  * x0.x  + h.x  * x0.y; g.yz = a0.yz * x12.xz + h.yz * x12.yw;  return 130.0 * dot(m, g);
}

float o_noise(float x, float z){
	float h = 0.0;
	for (int i=0;i<9;i++){
		h+= pow(2.0,-float(i)) * snoise(vec2(x,z) * 0.3 * pow(2.0, float(i)));
	}
	return (h* 0.5) + 0.5;
}

float constant_h(float x, float z){
	return 0.1;
}

float sin_noise_h(float x, float z){
	return 0.5 * sin(x*2.0) + 0.25*sin(x*4.0) + 0.125*sin(x*8.0) + 0.0625*sin(x*16.0) + 0.03125*sin(x*32.0)
		+ 0.5 * cos(z*2.0) + 0.25*cos(z*4.0) + 0.125*cos(z*8.0) + 0.0625*cos(z*16.0) + 0.03125*cos(z*32.0);
}

float simple_sincos_h(float x, float z){
	return (sin(x*5.0) + cos(z*7.0) + 1.4) * (1.0/2.8);
}

float height(float x, float z){
	return height_scale * o_noise(x,z);
}

float get_ray(vec3 origin, vec3 ray){
	const float min = 0.1;
	const float max = 20.0;
	const float fake_delta = 0.1;

	float delta = 0.5;
	float i = min;

	float last_h = 0.0;
	float last_y = 0.0;
	float h;

	vec3 point;

	for (float fake_i = min; fake_i < max; fake_i += fake_delta){
		
		point = origin + i * ray;

		h = height(point.x,point.z);

		if (point.y < last_h){
			return i - delta + delta * (last_h - last_y)/(point.y - last_y - h + last_h);
		}

		last_h = h;
		last_y = point.y;

		i += delta;
		delta = 0.01 * i;
	}

	return -0.1;
}

vec3 get_normal(vec3 point){
	return normalize(vec3(	height(point.x - eps, point.z) - height(point.x + eps, point.z),
				5.0 * eps,
				height(point.x,point.z - eps) - height(point.x, point.z + eps)));
}

vec4 get_shading(vec3 point, vec3 normal){
	vec3 light_p = vec3(10.0,20.0,10.0);
	
	vec3 light_d = normalize(light_p - point);
	vec3 eye = normalize(camera - point);
	
	float scaled_h = 1.0;
	float scaling_f = 1.0;
	
	//i<j where j=exponential scaling factor
	for (int i = 0;i<=4; i++){
		scaled_h *= point.y;
		scaling_f *= 1.0/height_scale;
	}
	
	vec3 colour = vec3(0.15,0.15,0.1) + vec3(1.0,1.0,1.0) * clamp(scaled_h*scaling_f*0.8, 0.0, 0.95);
	
	
	float diffuse = max(0.0, dot(normalize(normal), light_d));
	float specular = pow(clamp(dot(eye,reflect(-light_d, normalize(normal))),0.0,1.0),20.0);

	float shadow = 0.0;
	shadow = clamp(get_ray(point,point + normal),0.0,0.4);
	
	vec3 final_colour = diffuse * colour + specular * 0.25 * colour + vec3(-1.0,-1.0,-1.0) * shadow;
	
	vec3 fog = 0.75 * vec3(1.0,1.0,1.0)  * min(0.5,point.z*point.z*point.z/100.0);

	return vec4(final_colour + fog, 1.0);
	return vec4(normal * 0.5 + 0.5,1.0);
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	vec3 origin = camera;
	vec3 dir = vec3(position.x,position.y - 0.3,1.0) - 0.5;

	float i = get_ray(origin, dir);

	vec3 point = origin + dir * i;
	vec3 normal = get_normal(point);

	if (i > 0.00){
		gl_FragColor = get_shading(point,normal) ;//* vec4(fog,fog,fog,1.0);
	}
	else {
		gl_FragColor = (1.0 - position.y) * vec4(1.0,1.0,1.0,1.0) + vec4(0.2,0.2,0.9,1.0);
	}

	//gl_FragColor = vec4(position, 0.0, 1.0);

}

