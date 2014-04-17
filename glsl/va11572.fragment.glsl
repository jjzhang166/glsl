#ifdef GL_ES
precision mediump float;
#endif

uniform vec2  resolution;
uniform float time;
uniform vec2 mouse;
const int num = 12;
const float PI = 3.141592;
const float penr = 0.8;



float pen(vec2 me)
{
	float t=time;
//	float r=1.0-smallr;

      //  vec2 p=vec2(r*cos(t),r*sin(t));
//	float t2=t-t/smallr;
//	float r2=smallr*penr;

//	vec2 p2=vec2(r2*cos(t2),r2*sin(t2));
	
//	return d2i(length(p+p2-me));
	return 1.0;
}
void main() {
	float color;
	float r = sqrt(pow(( mouse.x*resolution.x -resolution.x/2.0), 2.0) + pow((resolution.y/2.0 - mouse.y*resolution.y), 2.0));
	r *= 1.0;
	for (int j = 0; j < num; ++j) {
		float x =  resolution.x*mouse.x + r*(cos( 1.2*time + float(j)/float(num) *(2.0*PI)));
		float y =  resolution.y*mouse.y + r*(sin( 1.9*time + float(j)/float(num) *(2.0*PI)));
		float size = 2.0 - 1.0 * sin(time);
		vec2 pos = vec2(x, y);
		float dist = length(gl_FragCoord.xy - pos);
		color += pow(size/dist, 2.0);
	}
	
	gl_FragColor = vec4(vec3(color), 1.0);
	
}