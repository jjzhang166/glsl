// by @slackito, @thebaktery, @TheJare

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;

vec3 light_pos = vec3(-2.0, 20.0, 20.0);
vec3 red_ball_pos;
vec3 blue_ball_pos;
float epsilon = 0.0001;

float sphere(vec3 ro, vec3 rd, vec3 center, float radius)
{
	vec3 ro2 = ro - center;
	float a = dot(rd, rd);
	float b = 2.0 * dot(rd, ro2);
	float c = dot(ro2, ro2) - radius*radius;
	float discriminant = b*b - 4.0*a*c;
	if (discriminant < 0.0) return 99999.;
	float s1 = (-b + sqrt(discriminant))/(2.*a);
	float s2 = (-b - sqrt(discriminant))/(2.*a);
	float result = min(s1, s2);
	if (result < 0.0) return 99999.;
	else return result;
}

float scene_s(vec3 ro, vec3 rd) // for shadow rays
{
	vec3 result = vec3(0.2, 0.2, 0.2); // bg
	float mind = 99999.;

	float d = sphere(ro, rd, vec3(0.0, -1000.0, 0.0), 1000.0);
	if (d < mind) { mind=d; }
	d = sphere(ro, rd, red_ball_pos, 1.0);
	if (d < mind) { mind=d; }
	d = sphere(ro, rd, blue_ball_pos, 1.0);
	if (d < mind) { mind=d; }

	return mind;
}

float cos2(float a) { float b = cos(a); return b*b; }

vec4 pal(float r)
{
	return vec4(cos2(r*23.0), cos2(r*17.0), cos2(r*37.0), 1);
}

vec4 checker(vec2 point)
{
        vec2 uv0 = point*.07 - vec2(0, 0);
        vec2 uv1 = point*.15 - vec2(0.5, 0.5);
	float r = sqrt(uv0.x*uv1.x + uv1.y*uv0.y);
	float a = atan(uv1.y, uv0.x);

 	return pal(r+time+a)*r;
}

vec3 scene2(vec3 ro, vec3 rd) // for secondary rays
{
	vec3 result = vec3(0.2, 0.2, 0.2); // bg
	float mind = 99999.;

	float d = sphere(ro, rd, vec3(0.0, -1000.0, 0.0), 1000.0);
	if (d < mind) {
		vec3 point = ro+rd*d; 
		result = checker(point.xz).xyz;
		mind=d;
	}
	d = sphere(ro, rd, red_ball_pos, 1.0);
	if (d < mind) { result = vec3(1.0, 0.3, 0.0); mind=d; }
	d = sphere(ro, rd, blue_ball_pos, 1.0);
	if (d < mind) { result = vec3(0.0, 0.2, 1.0); mind=d; }

	return result;
}


vec3 scene(vec3 ro, vec3 rd)
{
	vec3 result = vec3(0.2, 0.2, 0.2); // bg
	float mind = 99999.;
	vec3 point;
	vec3 normal;
	vec4 color;

	vec3 center = vec3(0, -1000.0, 0);
	float d = sphere(ro, rd, center, 1000.0);
	if (d < mind) { 
	  point = ro+rd*d; normal = normalize(point-center);
	  color = checker(point.xz);
	  mind=d;
	}
	
	d = sphere(ro, rd, red_ball_pos, 1.0);
	if (d < mind) { point = ro+rd*d; normal = normalize(point-red_ball_pos); color = vec4(1.0, 0.3, 0.0, 0.3); mind=d; }
	
	d = sphere(ro, rd, blue_ball_pos, 1.0);
	if (d < mind) { point = ro+rd*d; normal = normalize(point-blue_ball_pos); color = vec4(0.0, 0.2, 1.0, 0.6); mind=d; }

	vec3 color2;
	if (color.w > 0.0)
	{
	  color2 = scene2(point + normal*epsilon, reflect(rd, normal));
	  color.xyz = color.xyz*(1.0-color.w) + color2*color.w;
	}
	vec3 L = light_pos - point;
	vec3 Ln = normalize(L);
	vec3 h = normalize(Ln - rd);
	float s = pow(clamp(dot(normal, h),0.0,1.0), 10.1);
	float dist_shadow = scene_s(point+normal*epsilon, Ln);
	if (dist_shadow < length(L))
	{
	  result = vec3(0.0, 0.0, 0.0);
	  s= 0.0;
	}
	else
	  result = dot(Ln, normal) * color.xyz;

	return result*min((900.0/(mind*mind)),1.0)+s;
}


void main( void ) {
	vec2 p = gl_FragCoord.xy / resolution.xy - vec2(0.5, 0.5);

	float aspect = resolution.x / resolution.y;
	float hfov = radians(70.0);
	vec3 eye = vec3(15.0*sin(0.2*time), 4.0, 15.0*cos(0.2*time));
	vec3 look = vec3(0.0, 1.0, 0.0);
	vec3 dir = normalize(look - eye);
	vec3 up = vec3(0.0, 1.0, 0.0);
	vec3 right = cross(dir, up);
	up = cross(right, dir);
	dir = dir + tan(0.5*hfov)*p.x*right + tan(0.5*hfov/aspect)*p.y*up;

	red_ball_pos = vec3(0.0, sin(time) + 1.0, 0.0);
	blue_ball_pos = vec3(sin(time), cos(time) + 1.0, sin(time) * 2.0);
	
	vec3 color = scene(eye, dir);	

	gl_FragColor = vec4( color, 1.0 );

}