// titan sux

#ifdef GL_ES
precision mediump float;
#endif

float time;
vec2 mouse=vec2(0,0);
vec2 resolution=vec2(400,400);

float deSphere(vec3 p, float r)
{
	return length(p) - r;
}

float de(vec3 p) 
{
	return deSphere(p, 1.0);
}

vec3 normal(in vec3 pos)
{
	float f = de(pos);
	vec3 e = vec3(0.001, 0.0, 0.0);
	vec3 n;
		
	n.x = de(pos + e.xyy) - de(pos - e.xyy);
	n.y = de(pos + e.yxy) - de(pos - e.yxy);
	n.z = de(pos + e.yyx) - de(pos - e.yyx);  
	
	return normalize(n);
}
void main( void ) 
{
	const float epsilon = 0.01;
	vec2 position = ((( gl_FragCoord.xy / resolution.xy ) * 2.0) - 1.0) * vec2(resolution.x / resolution.y, 1.0);
	vec3 ray = vec3(0.0, 0.0, -2.0);
	vec3 cam = vec3(position.x, position.y, 1.0);
	vec3 direction = normalize(cam);
	vec4 color = vec4(0.0);
	vec2 m = (mouse * 2.0) - 1.0;
	vec3 light = vec3(m.x, m.y, -2.5) * vec3(2.0, 2.0, 1.0);
	
	for(int i = 0; i < 20; i++) {
		float dist = de(ray);
		if(dist < epsilon) {
			vec3 n = normal(ray);
			vec3 l = normalize(light - ray);
			
			// diffuse
			float lt = clamp(dot(l, n), 0.0, 1.0);
			color = lt * vec4(1.0);
			
			// light attenuation
			float atte = 1.0 / length(light - ray);
			color *= atte;
			
			// specular
			vec3 e = -direction;
			vec3 h = normalize(l + e);
			float s = pow(dot(h, n), 20.0) * 0.5;
			color += vec4(s);
			
			break;
		}		
		
		ray += 0.75 * direction * dist;
	}
	
	gl_FragColor = vec4(color.xyz, 1.0);
}