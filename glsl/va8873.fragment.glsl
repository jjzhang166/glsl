#ifdef GL_ES
precision mediump float;
#endif

/*float time = iGlobalTime;
vec4 mouse = iMouse;
vec3 resolution = iResolution;
*/

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

struct Line{
	vec3 loc;
	vec3 dir;
	vec3 color;
	float t;
	int id_obj;
};
	
struct Material{
	vec3 ambient;
	vec3 difuse;
	vec3 specular;
};
	
struct Sphere{
	vec3 loc;
	Material mat;
	float r;
};

struct Light{
	vec3 loc;
	vec3 color;
};
	
Material red = Material(vec3(0.3,0.0,0.0),vec3(0.6,0.0,0.0),vec3(0.8,0.0,0.0));
Material blue = Material(vec3(0.0,0.0,0.3),vec3(0.0,0.0,0.6),vec3(0.0,0.0,0.8));
Material green = Material(vec3(0.0,0.3,0.0),vec3(0.0,0.6,0.0),vec3(0.0,0.8,0.0));
vec3 background_color = vec3(0.8,0.8,0.8);
Sphere sph3 = Sphere(vec3(-3.0,1.0,-2.0),red,1.0);
Sphere sph4 = Sphere(vec3(1.0,1.0,3.0), green,1.0);
Sphere sph[2];
Light light = Light(vec3(0.0,1.0,0.0),vec3(1.0));


bool sphere_hits(in Line line, out float t, Sphere sphere){
	vec3 p0 = line.loc - sphere.loc;
	vec3 v = line.dir;
	float b = 2.0*dot(p0,v);
	float c = dot(p0,p0) - sphere.r*sphere.r;
	float D = b*b -4.0*c;
	if (D < 0.0) return false;
	if (D == 0.0){
		t = (-b)/2.0;
		return true;
	}
	if (D > 0.0){
		float t0,t1;
		t0 = (-b + sqrt(D))/2.0;
		t1 = (-b - sqrt(D))/2.0;
		if ( t0 < t1 && t0 > 0.0) t = t0;
		else if (t1 < t0 && t1 > 0.0) t = t1;
		else return false;
		return true;
	}
	return false;
}

vec3 sphere_norm(Sphere sphere, vec3 hit_loc){
	return normalize(hit_loc - sphere.loc);
}

vec3 plane_norm(vec3 hit_loc){
	return normalize(vec3(0.0,1.0,0.0));
}

bool plane_hits(in Line line, out float t){
	vec3 n = vec3(0.0,1.0,0.0);
	//t = (0.0 - dot(line.loc,n)/dot(line.dir,n));
	t = - line.loc.y/line.dir.y;
	return true;
}

bool intersect(inout Line line){
	float t_hit = 0.0;
	float best_hit = 0.0;
	int best_obj = -1;
	
	//for each sphere
	for(int i = 0; i < 2; i++){
		int obj = i;
		
		//if ray hit with sphere i
		if (sphere_hits(line,t_hit,sph[i]))
			if (t_hit < best_hit || best_obj < 0){
				best_hit = t_hit;
				best_obj = obj;
			}
	}
	
	//if ray doesn't hit with any sphere then check if hit with plane
	if (best_obj < 0){
		if (plane_hits(line,t_hit))
			if (t_hit < best_hit || best_obj < 0){
				best_hit = t_hit;
				best_obj = 100;
			}
	}
	
	//check if hit is infront camera
	if (best_obj >= 0){
		line.id_obj = best_obj;
		line.t = best_hit;
		return true;
	}
	
	return false;
}

void calculateColor(inout Line line){
	vec3 Pi = line.loc + line.dir*line.t;
	vec3 N;
	vec3 Kd,Ks,Ka;
	if (line.id_obj != 100){
		N = sphere_norm(sph[0],Pi);
		Kd = sph[0].mat.difuse;
		Ks = sph[0].mat.specular;
		Ka = sph[0].mat.ambient;
	}else{
		N = plane_norm(Pi);
		Kd = vec3(0.7);
		Ks = vec3(0.8);
		Ka = vec3(0.3);
	}
	vec3 E = -line.dir;
	vec3 Er = reflect(E,N);
	Line LRefl = Line(Pi+Er*0.0001,Er,vec3(1.0),0.0,-1);
	
	float gloss = 50.0;
	
	
	//foreach light
	vec3 L = light.loc - Pi;
	float d = length(L);
	L = normalize(L);
	
	vec3 Cl = light.color;
	//shadow

	//

	float NdotL = dot(N,L);
	if (NdotL <= 0.0) NdotL = 0.0;
	vec3 diffuse = NdotL*Kd;
	float LdotEr = dot(L,Er);
	if (LdotEr <= 0.0) LdotEr = 0.0;
	vec3 specular = pow(LdotEr,gloss)*Ks;
	line.color = line.color + ((diffuse + specular).xyz*Cl.xyz);
}

void background (inout Line line){
	line.color = background_color;
}


void trace(inout Line line){
	if (intersect(line)){
		calculateColor(line);
	}else {
		background(line);
	}
}

void main(void)
{
	sph[0] = sph3;
	sph[1] = sph4;

	vec2 p = gl_FragCoord.xy/resolution.xy;
	p = -1.0 + 2.0*p;
	p.x *= resolution.x/resolution.y;

	vec3 lookAt = vec3(0.0, 0.0, 0.0);
	vec3 ro = vec3(9.0,3.0,0.0); //camera position
	vec3 front = normalize(lookAt - ro);
	vec3 left = normalize(cross(vec3(0,1,0), front));
	vec3 up = normalize(cross(front, left));
	vec3 rd = normalize(front*1.5 + left*p.x + up*p.y); // rect vector
	
	Line line = Line(ro,rd,vec3(0.0),0.0,-1);		// create ray with (loc,dir,color,distance to hit(0.0 initial), object hitted(no object hitted)) 
	
	trace(line);
	
	gl_FragColor = vec4(line.color,1.0);
	
}