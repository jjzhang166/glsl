#ifdef GL_ES
#define TYPE_NULL 0
#define TYPE_LIGHT 1
#define TYPE_BALL 2
#define TYPE_CAM 3
#define TYPE_FRAC 4
#define ZERO vec3(0.0,0.0,0.0)
#define ONE4 vec4(1.0,1.0,1.0,1.0)
#define ZERO_DATA Data(vec3(0.0,0.0,0.0), 0.0,null)
#define RED = vec4(1.0,0.0,0.0,0.0)
#define GREEN = vec4(0.0,1.0,0.0,0.0)
#define BLUE = vec4(0.0,0.0,1.0,0.0)
#define WHITE = vec4(1.0,1.0,1.0,0.0)

#define MAX_IT 20
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
const float stp = 1.0;
const float maxD = 1000.0;
const float dist = 500.0;

struct Object {
	vec3 pos;
	float r;
	int type;
};
	
struct Data {
	vec3 pos;
	float steps;
	Object obj;
};

bool ball(vec3 pos, vec3 chck, float r) {
	if (distance(pos, chck) < r) {
		return true;
	} else {
		return false;
	}
}

Object bll = Object(vec3(0.0,0.0,5.0), 1.0, TYPE_BALL);
Object light = Object(vec3(0.0,0.0,5.0), 0.0, TYPE_LIGHT);
Object null = Object(vec3(0.0,0.0,0.0), 0.0, TYPE_NULL);
Object cam = Object(vec3(0.0,0.0,-3.0), 0.0, TYPE_CAM);

float DE(vec3 pos) {
	vec3 Opos = pos;
	float dr;
	for(int i = 0; i<MAX_IT; i++) {
		pos = clamp(pos,-1.0,1.0)*2.0-pos;
		
		if (length(pos) < 0.5) {pos *= 4.0;} else if (length(pos) < 1.0) {pos /= pow(length(pos), 2.0);}
		pos = 2.0*pos + Opos;
		dr = dr*abs(2.0) + 1.0;
		
	}
	return 0.0;
	//if(length(pos) < 2.0) {return true;} else {return false;}
	//return length(pos)/abs(dr);
}

Data castRay(vec3 pos) {
	vec3 base = normalize(pos)-cam.pos;
	vec3 current = base;
	for(float n = 1.0; n<maxD; ++n) {
		current = base*n*stp;
		//if (DE(current) == true) {return Data(current, n, Object(ZERO, 0.0, TYPE_FRAC));}
		if (ball(bll.pos, current, bll.r) == true) {return Data(current, n, bll); break;}
	}
	return ZERO_DATA;
}
vec3 getObjectNormal(Data data) {
	if (data.obj.type == TYPE_BALL) {
		return data.pos-data.obj.pos;
	} else {
		return ZERO;
	}
}

float VecsToShade(vec3 v1, vec3 v2) {
	float res = dot(v1, v2)/(length(v1)*length(v2));
	return res;
}

void main( void ) {
	bll.pos = vec3(sin(time)*2.0, cos(time)*2.0, 10.0);
	Data hit = castRay(normalize(vec3(gl_FragCoord.x-resolution.x/2.0, gl_FragCoord.y-resolution.y/2.0, dist)));
	if(hit.obj.type != TYPE_NULL) {
		vec3 norm = getObjectNormal(hit);
		if(hit.obj.type == TYPE_FRAC) {
			gl_FragColor = ONE4*(hit.steps/14.0);
		}
		if (dot(hit.pos-light.pos, getObjectNormal(hit)) < 0.0) {
			//gl_FragColor = vec4(VecsToShade(light.pos-hit.pos, getObjectNormal(hit)),0.0,0.0,0.0);
		}
	}
	
}