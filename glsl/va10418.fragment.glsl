#ifdef GL_ES
precision mediump float;
#endif

//hrrrm.... missing transform

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float trace(vec3 pos,vec3 dir, vec3 obj);
vec3 sh(vec4 x, vec4 y, vec4 z, vec3 n);

void main( void ) {
	vec3 xyz = .5-vec3(gl_FragCoord.xy / resolution.xy, -gl_FragCoord.x / resolution.x);
	
	vec3 sPos = xyz-vec3(.0, .0, -.5) - vec3(mouse, 0.);
	vec3 cPos = vec3(-.5, -.5, .0);
	vec3 cDir = vec3(0., 0., 1.);
	
	float res = trace(cPos, cDir, sPos);
	
	gl_FragColor = vec4(res);
}

float trace(vec3 pos,vec3 dir, vec3 obj){
	float len = 0.;
	float dist = 0.;

	float res = 0.;
	for (int i = 0; i < 32; i++){
		vec3 p = pos+dir*len;
		
		dist = distance(obj, p);
		
		if(dist < .1){
			res = dist/float(i)*length(p);
			break;
		}
		
		len += dist;
	}
	
	return res;
}

vec3 sh(vec4 x, vec4 y, vec4 z, vec3 n){ 
	vec3 sh;
	vec4 bn = vec4(n, 1.0);
	sh.x	 = dot(x, bn);
	sh.y	 = dot(y, bn);
	sh.z	 = dot(z, bn);
	
	return clamp(sh, 0., 1.);
}
