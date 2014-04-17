#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.141592653589793;

float sdSphere(vec3 p, float r) {
	return length(p) - r;
}

float udBox(vec3 p, vec3 b) {
	return length(max(abs(p) - b, 0.0));
}

float sdPlane(vec3 p, vec4 n) {
	return dot(p, n.xyz) + n.w;
}

float scene(vec3 p) {
	float d = 0.0;
	d = sdSphere(p, 2.5);
	d = max(udBox(p, vec3(2.0)), -d);
	d = min(sdSphere(p + vec3(sin(time) * 5.0, 0.0, 0.0), 1.2), d);
	d = min(sdSphere(p + vec3(0.0, cos(time) * 5.0, 0.0), 1.2), d);
	d = min(udBox(p + vec3(0.0, 0.0, 2.0), vec3(10.0, 10.0, 0.1)), d);
	return d;
}

vec3 calcNormal(vec3 p) {
	vec3 epsilon = vec3(0.001, 0.0, 0.0);
	vec3 normal = normalize(vec3(
		scene(p + epsilon.xyy) - scene(p - epsilon.xyy),
		scene(p + epsilon.yxy) - scene(p - epsilon.yxy),
		scene(p + epsilon.yyx) - scene(p - epsilon.yyx)
	));
	return normal;
}

float shadow(vec3 ro, vec3 rd) {
	float t = 0.0;
	float d = 0.0;
	for(int i = 0; i < 100; i++) {
		d = scene(ro + rd * t);
		if(d < 0.001) {
			return 0.5;
		}
		t += d;
	}
	return 1.0;
}

float softshadow(vec3 ro, vec3 rd, float k) {
	float t = 0.0;
	float d = 0.0;
	float res = 1.0;
	for(int i = 0; i < 30; i++) {
		d = scene(ro + rd * t);
		if(d < 0.001) {
			return 0.0;
		}
		res = min(res, k * d / t);
		t += d;
	}
	return clamp(res, 0.0, 1.0);
}

bool trace(vec3 ro, vec3 rd, float mint, float maxt, out vec3 p) {
	float t = 0.0;
	float d = 0.0;
	for(int i = 0; i < 100; i++) {
		p = ro + rd * t;
		d = scene(p);
		if(abs(d) < mint || t > maxt) {
			break;
		}
		t += d;
	}	
	return d < mint;	
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

void main( void ) {

	vec2 uv = gl_FragCoord.xy / resolution;
	vec3 ro = vec3(0.0, 0.0, 10.0);
	vec3 rd = normalize( vec3( (uv * 2.0 - 1.0) * vec2(resolution.x / resolution.y, 1.0), -1.0) );
	vec3 p = vec3(0.0);
	
	mat3 rotation = axis_y_rotation_matrix((1.0 - mouse.x * 2.0) * PI);
	rotation *= axis_x_rotation_matrix((mouse.y * 2.0 - 1.0) * PI);
	
	ro *= rotation;
	rd *= rotation;
	
	bool hit = trace(ro, rd, 0.001, 100.0, p);
	vec3 c = vec3(0.0);
	if(hit) {
		vec3 nor = calcNormal(p);
		vec3 lightPos = vec3(30.0 * cos(time), 30.0 * sin(time), 40.0);
		vec3 lightDir = normalize(lightPos - p);
		//float sh = shadow(p + lightDir * 0.01, lightDir);
		float sh = softshadow(p + lightDir * 0.01, lightDir, 8.0);
		float spec = pow(max(0.0, dot(reflect(rd, nor), lightDir)), 64.0) * sh;
		c = vec3(dot(nor, lightDir)) * sh + spec;
	}
	else {
		c = vec3(0.0, 0.5, 0.5);
	}
	gl_FragColor = vec4( c, 1.0 );
}