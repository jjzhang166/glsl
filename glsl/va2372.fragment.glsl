#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
float intersect(in vec3 ro, in vec3 rd);
float iSphere(in vec3 ro, in vec3 rd);

void main( void ) {
	vec3 rgb = vec3(0.0);
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	
	vec3 ro = vec3(0.0,1.0,4.0);
	vec3 rd = normalize( vec3( (-1.0+2.0*uv) * vec2(1.78,1.0),-1.0) );
	float id = intersect(ro,rd);
	if(id > 0.0){
		rgb = vec3(1.0);
	}
	
	
	
	gl_FragColor = vec4(rgb,19.0);
}

float intersect(in vec3 ro, in vec3 rd){
	float t = iSphere(ro,rd);
	return t;	
}

float iSphere(in vec3 ro, in vec3 rd){
	float r = 1.0;
	float b = 2.0 * dot(ro,rd);
	float c = dot(ro,ro) - r*r;
	float h = b*b - 4.0*c;
	if(h < 0.0) return -1.0;
	float t = (-b - sqrt(h))/2.0;
	return t;
}