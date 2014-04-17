
// Colorful raytraced balls by JvB
// A preview of our upcoming revision 2013 demo?

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


#define PI 3.1415926535
vec3 get_sphere_pos(int i)
{
	
	float a = float(i)*2.0*PI/10.0+ 0.0*time; 
	return vec3(sin(a*0.1),cos(a*0.1),mix(sin(a*0.4),sin(a*0.2), sin(time)*0.5+0.5)); 
}
vec3 get_sphere_color(int i) 	
{
	vec3 color = vec3(0); 
	float a = mod(-time*1.0+float(i)*0.0, 1.3); 
	
	if (a >= 0.0 && a < 0.1) color = vec3(0,0,0); 
	if (a >= 0.1 && a < 0.2) color = vec3(0,0,1); 
	if (a >= 0.2 && a < 0.3) color = vec3(1,0,0); 
	if (a >= 0.3 && a < 0.4) color = vec3(0,1,0); 
	if (a >= 0.4 && a < 0.5) color = vec3(1,1,0); 
	if (a >= 0.5 && a < 0.6) color = vec3(0,1,1); 
	if (a >= 0.6 && a < 0.7) color = vec3(1,1,1); 
	if (a >= 0.7 && a < 0.8) color = vec3(0,1,1); 
	if (a >= 0.8 && a < 0.9) color = vec3(1,1,0); 
	if (a >= 0.9 && a < 1.0) color = vec3(0,1,0); 
	if (a >= 1.0 && a < 1.1) color = vec3(1,0,0); 
	if (a >= 1.1 && a < 1.2) color = vec3(0,0,1); 
	return color; 
}

float isph(in vec3 ro, in vec3 rd, in vec3 pos)
{
	ro -= pos; 
	float r = 0.1;  
	float A = dot(rd, rd); 
	float B = 2.0*dot(ro, rd); 
	float C = dot(ro, ro) - r*r; 
	
	float disc = B*B - 4.0*A*C;
	if (disc < 0.0)
		return -1.0; 
	float discSqrt = sqrt(disc); 
	float q; 
	if (B < 0.0)
		q = (-B - discSqrt)/2.0; 
	else
		q = (-B + discSqrt)/2.0; 
	float t0 = q/A; 
	//return t0; 
	float t1 = C/q; 
	return min(t0,t1); 
	
}

vec3 get_sphere_normal(in vec3 p, int obj)
{
	return normalize(p-get_sphere_pos(obj)); 
}



vec3 rotatey(in vec3 p, float ang)
{
	return vec3(p.x*cos(ang)-p.z*sin(ang), p.y, p.x*sin(ang)+p.z*cos(ang)); 
}
vec3 rotatex(in vec3 p, float ang)
{
	return vec3(p.x, p.y*cos(ang)-p.z*sin(ang), p.y*sin(ang)+p.z*cos(ang)); 
}
vec3 rotatez(in vec3 p, float ang)
{
	return vec3(p.x*cos(ang)-p.y*sin(ang), p.x*sin(ang)+p.y*cos(ang), p.z); 
}
void main( void ) {

	vec2 p = 2.0*( gl_FragCoord.xy / resolution.xy ) - 1.0;
	p.x *= resolution.x/resolution.y;
	
	vec3 color = vec3(1,1,1)*(0.1 + (1.0-length(p))*0.2);  	


	vec3 ro = vec3(0.5,0,2.0);
	vec3 rd = normalize(vec3(p.x,p.y,-1.0)); 

	float dir = 1.0;
	if (mod(time, 10.0) > 5.0)
		dir = -dir; 
	ro = rotatey(ro, time*dir); 
	rd = rotatey(rd, time*dir); 
	ro = rotatex(ro, time*0.2*dir); 
	rd = rotatex(rd, time*0.2*dir); 
	ro = rotatez(ro, time*0.1*dir); 
	rd = rotatez(rd, time*0.1*dir); 
	
	vec3 pos;
	float tmin = 10000.0; 
	int obj = 0; 
	for (int i = 0; i < 100; i+=1) {
		float a = float(i) + time; 
	 	float t = isph(ro,rd, get_sphere_pos(i)); 
		if (t > 0.0 && t < tmin) {
			tmin = t; 
			obj = i; 
		}
	}
	if (tmin > 0.0 && tmin < 100.0) {
		pos = ro + tmin*rd;
		vec3 n = get_sphere_normal(pos, obj); 
		vec3 r = reflect(rd, n); 
		float diff = clamp(dot(n, vec3(1,1,0)), 0.0, 1.0); 
		color = diff*get_sphere_color(obj)*2.0; 
		color *= 10.0*(pos.y - get_sphere_pos(obj).y); 		
	}
	
	
	gl_FragColor = vec4(color, 1.0); 
}