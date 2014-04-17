// triangles with better AA
// by @neoneye

//patterns! :D
// @scratchisthebes
#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;


vec2 rotate(vec2 point, float rads) {
	float cs = cos(rads);
	float sn = sin(rads);
	return point * mat2(cs, -sn, sn, cs);
}	


void main(void){
	float rads = radians(time*5.15);
	
	vec2 pos=gl_FragCoord.xy - resolution * 0.5; 
	pos = rotate(pos, rads);
	
	float size2 = 40.0;
	float size1 = size2 * 0.2;
	
	vec2 p0 = rotate(pos, radians(0.0));
	vec2 p1 = rotate(pos, radians(120.0));
	vec2 p2 = rotate(pos, radians(240.0));
	p0 = mod(p0, size2);
	p1 = mod(p1, size2);
	p2 = mod(p2, size2);
	
	int i=1;
	if(p0.x > size1) { i*=-1; }
	if(p1.x > size1) { i*=-1; }
	if(p2.x > size1) { i*=-1; }
			 
	float a = 1.0;
	if(i < 0) a = 0.0;
	
	p0 = mod(p0, size1);
	p1 = mod(p1, size1);
	p2 = mod(p2, size1);
	if(p0.x > -1.0 && p0.x < 1.0) a = 1.0 - abs(p0.x);
	if(p1.x > -1.0 && p1.x < 1.0) a = 1.0 - abs(p1.x);
	if(p2.x > -1.0 && p2.x < 1.0) a = 1.0 - abs(p2.x);
	

	vec4 kBlack = vec4(0,0,0,1.0);
	vec4 kWhite = vec4(1,1,1,1.0);
	vec4 result = mix(kWhite, kBlack, a);
	
	
	gl_FragColor=result;
}
