#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 rotate(vec3 p, vec3 v, float a){
	a = radians(a);
	v = normalize(v);
	float cosa = cos(a);
	float sina = sin(a);
	float omc = 1.0 - cosa; // one minus cos(a)
	mat3 m = mat3(
		v.x*v.x*omc + cosa,     v.y*v.x*omc - v.z*sina, v.z*v.x*omc + v.y*sina,
		v.x*v.y*omc + v.z*sina, v.y*v.y*omc + cosa    , v.z*v.y*omc - v.x*sina,
		v.x*v.z*omc - v.y*sina, v.y*v.z*omc + v.x*sina, v.z*v.z*omc + cosa
	);
	return p*m; 
					 
}

float uRoundBox( vec3 p, vec3 b, float r )
{
  return length(max(abs(p)-b,0.0))-r;
}

float bricks(vec3 p){
	float bricks = uRoundBox(vec3(mod(p.x,3.0) - 1.5, p.y, p.z), vec3(1.4,0.9,1.8), 0.3);
	return bricks;
}

float sphere(vec3 p,  float radius){
	return length(p) - radius;
}

float suelo(vec3 p){
	//float rnd = 0.15*clamp(fbm(0.5*p), 0.0, 1.0);
	return uRoundBox(vec3(mod(p.x,8.0) - 4.0, p.y + 3.6, mod(p.z, 8.0) - 4.0), vec3(3.8,3.8,3.8), 0.5);

}


/*
float cube(vec3 p, float size){
	return max(abs(p)) - size;
}
*/
float map(vec3 p){
	//return sphere(p , 10.0);
	float b = uRoundBox(rotate(p, vec3(0.0, 1.0, 0.0), 45.0), vec3(10.0), 2.0);
	float s = sphere(p, 10.0);
	float suel = suelo(p);
	return min(suel, s);
	
}

float intersects(vec3 ro, vec3 rd){
	
	float dist = 0.0;
	vec3 rp = ro;
	float dt;
	for(int i = 0; i < 32; ++i){
		dist = map(rp);
		if(dist <= 0.01) break;
		if(dist >= 1000.0) break;
		dt += dist;
		rp = ro + rd*dt;
	}
	if(dt < 1000.0) return dt;
	return -1.0;
}

vec3 getNorm(vec3 p){
	vec3 norm;
	norm.x = map(p + vec3(0.0001, 0.0,0.0))    - map(p- vec3(0.0001, 0.0,0.0));
	norm.y = map(p + vec3(0.0, 0.0001,0.0))    - map(p- vec3(0.0, 0.0001,0.0));
	norm.z = map(p + vec3(0.0, 0.0,0.0001))    - map(p- vec3(0.0, 0.0,0.0001));
	return normalize(norm);
}

void main( void ) {

	vec2 p = gl_FragCoord.xy/resolution.xy;
	p = -1.0 + 2.0*p;
	p.x *= resolution.x/resolution.y;
	vec3 lookAt = vec3(0.0,8.0, -25.0);
	vec3 ro = vec3(0.0, 12.0, 35.0); //camera position
	vec3 front = normalize(lookAt - ro);
	vec3 left = normalize(cross(vec3(0.0, 1.0, 0.0), front));
	vec3 up = normalize(cross(front, left));
	vec3 rd = normalize(front*1.5 + left*p.x + up*p.y); // rect vector
	

	vec3 bground = vec3(0.0, 0.0, 0.0);
	//store the final color in the FragColor
	vec3 color = vec3(1.0, 1.0, 1.0);
	float t = intersects(ro, rd);
	vec3 lpos = rotate(vec3(0.0, 10.0, 25.0), vec3(0.0, 1.0, 0.0), time*50.0);
	//normalize(l);
	if(t  >= 0.0){
		
		vec3 p = ro + rd*t;
		vec3 l = normalize(lpos - p);
		
		vec3 norm = getNorm(ro + rd*t);

		float nl = max(0.0, dot(norm,l));
		float ndote = max(dot(norm, -rd), 0.0);
		vec3 er = normalize(rd +2.0*ndote*norm);
	
		float spec;

		spec = pow(max(dot(l,er),0.0),15.0);
		color = 0.05 * color + vec3(nl) + vec3(spec);
		//color = spec * color +  nl * color;

	}
	else color = bground;
	gl_FragColor = vec4(color,1);
}