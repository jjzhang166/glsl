#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float distance(vec3 pos) {
	return length(max(max(abs(fract(pos)-.5)-.2,0.), abs(pos)-2.75));
}

vec3 color(vec3 pos) {
	vec3 edge = abs(abs(fract(pos)-.5)-.2);
	edge += edge.yzx;
	float onedge = min(edge.x,min(edge.y,edge.z));
	
	float random = sin(.123+dot(floor(pos),vec3(.1465345,.43215,.624123))*100.);
	return onedge < .05 ? vec3(.5) : random > 0. ? vec3(.5,0,0):vec3(0,.5,0);
}


void main( void ) {
	vec3 lookAt = vec3(0);
	vec3 dir = normalize(vec3(mouse.x-.5,mouse.y-.5,1.));
	vec3 left = normalize(cross(dir,vec3(0,1,0)));
	vec3 up = cross(dir,left);
	
	vec3 pos = -dir*10.;
	
	vec2 screen = (gl_FragCoord.xy-resolution*.5)/resolution.x;
	
	vec3 ray = normalize(dir+left*screen.x+up*screen.y);
	
	float dsum = 0.;
	float d;
	
	for (int i = 0; i < 100; i++) {
		d = distance(pos);
		dsum += d;
		pos += d*ray;
	}
	
	
	gl_FragColor = vec4(vec3(dsum+d*20.)*.05+color(pos),1.);

}