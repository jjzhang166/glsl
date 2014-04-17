#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define pi 3.14159265

float ray_distance(vec3 p0, vec3 d0, vec3 p1, vec3 d1) {
	vec3 d21 = -d0;
	//Vector3 d21 = p1-p2; // 3 sub x 3
	vec3 d34 = +d1;
        //Vector3 d34 = p4-p3;
	vec3 d13 = p1 - p0;
        //Vector3 d13 = p3-p1;
	// m * u = x
	float a = dot(d21, d21); // (3 mul + 3 add ) x 5
	float b = dot(d21, d34);
	float c = dot(d34, d34);
	float d = dot(-d13, d21);
	float e = dot(-d13, d34);
	// Solve for u1 &amp;amp;amp;amp;amp;amp;amp;amp; u2
	float u0 = (d*c-e*b)/(c*a-b*b); // 4 mul, 2 sub, 1 div
	float u1 = (e - b * u0) / c; // 1 mul, 1 sub, 1 div
	
	if (u0 < 0.0) u0 = 0.0;
	return distance(p0 + u0 * d0, p1 + u1 * d1);
}

vec3 hsv_to_rgb(vec3 hsv) {
	float h = hsv.x / 60.0;
	float s = hsv.y;
	float v = hsv.z;
	
	float chroma = v * s;
	float x = chroma * (1.0 - abs(mod(h, 2.0) - 1.0));
	
	vec3 rgb = vec3(0.0);
	if      (h < 1.0)  { rgb.r = chroma; rgb.g = x;      }
	else if (h < 2.0)  { rgb.r = x;      rgb.g = chroma; }
	else if (h < 3.0)  { rgb.g = chroma; rgb.b = x;      }
	else if (h < 4.0)  { rgb.g = x;      rgb.b = chroma; }
        else if (h < 5.0)  { rgb.r = x;      rgb.b = chroma; }
	else if (h <= 6.0) { rgb.r = chroma; rgb.b = x;      }
	float m = v - chroma;
	rgb.r += m;
	rgb.g += m;
	rgb.b += m;
	return rgb;
}

void main( void ) {
	float color = 0.0;
	
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	float ratio = pi * 75.0 / 360.0;
	
	vec2 offset = position - 0.5;
	
	vec3 origin = vec3(0.0, 0.0, 0.0);
	vec3 direction = vec3(
		sin(offset.x * ratio),
		sin(offset.y * ratio),
		cos(offset.x * ratio) * cos(offset.y * ratio)
	);
	
	vec3 target = vec3(0.0, 0.0, 5.0 + sin(time));
	vec3 delta = target - origin;
	
	vec3 linedir = normalize(vec3(
		cos(time*0.5+cos(time*0.5)) * sin(time*0.3+cos(time)),
		cos(time*0.5+cos(time*0.5)) * cos(time*0.3+cos(time)),
		sin(time*0.5+cos(time*0.5))
	));
	
	float point_distance = length(delta - direction*dot(delta, direction));
	
	if (point_distance < 0.5) color += point_distance / 2.0;
	
	float linedist = ray_distance(origin, direction, target, linedir);
	
	color = linedist * 10.0;
	
	/*
	vec2 eye = position - vec2(0.0, 0.5);
	vec2 direction = normalize(mouse - vec2(0.0, 0.5));
	float dist = length(eye);
	float cosy = dot(eye, direction) / dist;
        float color = cosy / dist;*/
	
	gl_FragColor = vec4( hsv_to_rgb( vec3(
		mod(color*100.0, 360.0),
		clamp(color * 0.5, 0.0, 1.0),
		clamp(sin( color + time / 3.0 ) * 0.75, 0.0, 1.0)
	) ), 1.0 );

}