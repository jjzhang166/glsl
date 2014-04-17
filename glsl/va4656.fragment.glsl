//by Muhammad Daoud

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;

vec4 p1 = vec4(0.0, 1.0, 0.0, 1.3);
vec4 p2 = vec4(0.0, - 1.0, 0.0, 1.3);
vec4 p3 = vec4(1.0, 0.0, 0.0, 1.3);
vec4 p4 = vec4(-1.0, 0.0, 0.0, 1.3);
vec4 p5 = vec4(0.0, 0.0, 1.0, 1.3);
vec4 s1 = vec4(0.0, -p1.w+0.25, 0.0, 0.25);




bool iP(vec4 p, vec3 o, vec3 rd, float tm, out float t){
 t = - (dot(p.xyz, o)+p.w)/dot(p.xyz,rd);
 return (t > 0.0) && (t < tm);
}

float inter(vec3 o, vec3 rd, out vec3 co, vec3 lp, float li){
 float tm = 10000.0;
 float t;

 if (iP(p1, o, rd, tm, t)){
 	vec3 pos = o + t*rd;
	float rm = 10000.0;
	float r;
	vec3 lgt = normalize(lp - pos);
	vec3 nor = p1.xyz;
	float dif = clamp(dot(nor, lgt)*(li-length(lp-pos)), 0.0, 0.5);
	co = vec3(1.0, 0.8, 0.6)*dif + vec3(0.6);
	
 	tm = t;
 }
 if (iP(p2, o, rd, tm, t)){
	vec3 pos = o + t*rd;
	vec3 lgt = normalize(lp - pos);
	vec3 nor = p2.xyz;
	float dif = clamp(dot(nor, lgt)*(li-length(lp-pos)), 0.0, 0.5);
	co = vec3(1.0)*dif + vec3(0.0);
 	tm = t;
 }
 if (iP(p3, o, rd, tm, t)){
 	vec3 pos = o + t*rd;
	float rm = 10000.0;
	float r;
	vec3 lgt = normalize(lp - pos);
	vec3 nor = p3.xyz;
	float dif = clamp(dot(nor, lgt)*(li-length(lp-pos)), 0.0, 0.5);
	co = vec3(1.0, 0.8, 0.6)*dif + vec3(0.0, 0.0, 1.0);

	tm = t;
 }
 if (iP(p4, o, rd, tm, t)){
 	vec3 pos = o + t*rd;
	float rm = 10000.0;
	float r;
	vec3 lgt = normalize(lp - pos);
	vec3 nor = p4.xyz;
	float dif = clamp(dot(nor, lgt)*(li-length(lp-pos)), 0.0, 0.5);
	co = vec3(1.0, 0.8, 0.6)*dif + vec3(1.0, 0.0, 0.0);

 	tm = t;
 }
 if (iP(p5, o, rd, tm, t)){
	vec3 pos = o + t*rd; 
	float rm = 10000.0;
	float r;
	vec3 lgt = normalize(lp - pos);
	vec3 nor = p5.xyz;
	float dif = clamp(dot(nor, lgt)*(li-length(lp-pos)), 0.0, 0.5);
	co = vec3(1.0, 0.8, 0.6)*dif + vec3(0.9);

 	tm = t;
 }
 return tm;	
}
	

void main(){
 vec2 uv = -1.0 + 2.0*gl_FragCoord.xy/resolution.xy;
 uv.x *= resolution.x/resolution.y;
 vec3 o = vec3(0.0, 0.0, 2.3);
 vec3 rd = normalize(vec3(uv, -1.0));
 vec3 lp = vec3(sin(time), sin(time), cos(time));
 float li = 2.0;
 vec3 co;	
 float t = inter(o, rd, co, lp, li);
 
 gl_FragColor = vec4(co, 1.0);
}