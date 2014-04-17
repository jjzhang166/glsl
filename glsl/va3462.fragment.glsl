#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 lightPosition = vec3(mouse.x * 100.0, mouse.y * 100.0, 10);

vec3 intersectSphere(vec3 camera, vec3 currentPosition, vec4 sphere) {

	float cx = sphere.x;
	float cy = sphere.y;
	float cz = sphere.z;
	float dx = camera.x - currentPosition.x;
	float dy = camera.y - currentPosition.y;
	float dz = camera.z - currentPosition.z;
	float x0 = camera.x;
	float y0 = camera.y;
	float z0 = camera.z;
	
	float R = sphere.a;

	
	float a = dx*dx + dy*dy + dz*dz;
        float b = 2.0*dx*(x0-cx) + 2.0*dy*(y0-cy) +  2.0*dz*(z0-cz);
        float c = cx*cx + cy*cy + cz*cz + x0*x0 + y0*y0 + z0*z0 -2.0*(cx*x0 + cy*y0 + cz*z0) - R*R;

	
	float discriminant = b * b - 4.0 * a * c;
	
	
	if (discriminant >= 0.0) { // This object hits the ray, cast a color out from it.
		
		float t = (-b - sqrt(discriminant)) / (2.0 * a);
		vec3 intersectionPoint = vec3(x0 + t * dx, y0 + t * dy, z0 + t * dz);
		vec3 N = vec3((intersectionPoint.x - cx) / R, (intersectionPoint.y - cy) / R, (intersectionPoint.z - cz) / R);
		
		vec3 L_ = lightPosition - intersectionPoint;
		vec3 L = L_ / length(L_);
		
		float factor = dot(N, L);
		
		float kd = 0.9;
		float ka = 0.5;
		vec3 col = vec3(1, 0.3, 0.3);
	
		return vec3(kd * factor * col.r, kd * factor * col.g, kd * factor * col.b) + col * ka;
		
	}	
	
	return vec3(0, 0, 0);
}

void main( void ) {


	
	// camera
	vec3 camera = vec3(0.5, 0.5, 32);

	// current position
	vec2 p1_ = ( gl_FragCoord.xy / resolution.xy );
	vec3 currentPosition = vec3(p1_.x, p1_.y, 0.0);
	
	vec4 sphere1 = vec4(0.2, 0.8, -40.0, 0.2);
	vec4 sphere2 = vec4(0.8, 0.2, -30.0, 0.4);
	
	vec3 color = intersectSphere(camera, currentPosition, sphere1);

	
	gl_FragColor = vec4(color, 1.0);

}