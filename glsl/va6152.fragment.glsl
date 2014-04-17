
#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


vec3 rotXaxis(vec3 p, float rad) {
	float z2 = cos(rad) * p.z - sin(rad) * p.y;
	float y2 = sin(rad) * p.z + cos(rad) * p.y;
	p.z = z2;
	p.y = y2;
	return p;
}

vec3 rotYaxis(vec3 p, float rad) {
	float x2 = cos(rad) * p.x - sin(rad) * p.z;
	float z2 = sin(rad) * p.x + cos(rad) * p.z;
	p.x = x2;
	p.z = z2;
	return p;
}
vec3 rotZaxis(vec3 p, float rad) {
	float x2 = cos(rad) * p.x - sin(rad) * p.y;
	float y2 = sin(rad) * p.x + cos(rad) * p.y;
	p.x = x2;
	p.y = y2;
	return p;
}

//t.x = torus center size, t.y = torus volume size
float Torus(vec3 p, vec2 t)
{
	vec2 q = vec2(length(p.xz)-t.x, p.y);
    	return length(q)-t.y;
}

float map( vec3 p ){
		
	p = rotXaxis(p, 3.1415/2. * time);
	p.y -= 0.010;
	
	return Torus(p, vec2(0.02, 0.010));
}

void main( void )
{
    	vec2 pos = (gl_FragCoord.xy*2.0 - resolution.xy) / resolution.y;
    	vec3 camPos = vec3(0., 0., 0.1);
    	vec3 camTarget = vec3(0.0, 0.0, 0.0);

    	vec3 camDir = normalize(camTarget-camPos);
    	vec3 camUp  = normalize(vec3(0.0, 1.0, 0.0));
    	vec3 camSide = cross(camDir, camUp);
    	float focus = 2.0;

	vec3 rayDir = normalize(camSide*pos.x + camUp*pos.y + camDir*focus);
    	vec3 ray = camPos;
    	float d = 0.0, total_d = 0.0;
 	const int MAX_MARCH = 32;
 	const float MAX_DIST = 0.11;
	vec4 result;
	int i;
	
    	for(int i=0; i<MAX_MARCH; ++i) {
        	d = map(ray);
        	total_d += d;
        	ray += rayDir * d;
        	if(abs(d)<0.001) {
			break;
		}
		if(total_d > float(MAX_DIST)) {
			total_d = float(MAX_DIST);
			break;
		}
    	}
	
	result = vec4(1. - (total_d / MAX_DIST),0.,0.,1.);
	gl_FragColor = result;
}