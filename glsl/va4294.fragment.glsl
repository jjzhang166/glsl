//MG
#ifdef GL_ES
precision mediump float;
#endif

//best viewed on 1
//cartoonish look :D

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float light(vec2);

void main() {
	vec2 p=(gl_FragCoord.xy/resolution.y)*50.0;
	p.x-=resolution.x/resolution.y*25.0;p.y-=25.0;
	
	gl_FragColor+=vec4(light(p) + 0.3,0.0,0.0,1.0);
}

float light(vec2 p) {
	vec3 dudv;
	float result;
	
	dudv.x=(p.x*sin(time-sqrt(p.x*p.x+p.y*p.y)))/sqrt(p.x*p.x+p.y*p.y);
	dudv.y=(p.y*sin(time-sqrt(p.x*p.x+p.y*p.y)))/sqrt(p.x*p.x+p.y*p.y);
	dudv.z=1.0;
	
	dudv=normalize(dudv);
	result=dot(dudv,normalize(vec3(1.0,1.0,1.0)));
	if (result<0.4) {result=0.0;}
	return result;
}