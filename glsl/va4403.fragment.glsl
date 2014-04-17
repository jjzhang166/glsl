#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform float count;
const float PI = 3.1415926535;
float bpm = 132.0 / 1200.;
float height = 2.0;
float horizSpeed = sin(0.5 * time);
float spinner = cos(time / 0.911);
int counter = 0;
vec2 rects[10];

float max3(float a,float b,float c)
{
	return max(a, max(b,c));
}


vec2 screenToWorldCoord(vec2 coord)
{
	vec2 unipos = (coord / resolution);
	vec2 pos = unipos*2.0-1.0;
	pos.x *= resolution.x / resolution.y;
	return pos;
}

float rect(vec2 p, vec2 b, float smooth )
{
	vec2 v = abs(p) - b;
  	float d = length(max(v,0.0));
	return 1.0-pow(d, smooth);
}

void updateRects(){
	counter = counter + 1;
	if (counter >= 10) counter = 0;
	if (counter == 0) {
		rects[0] = vec2(cos(time),sin(time));
	} else if(counter == 1) {
		rects[1] = vec2(cos(time),sin(time));
	} else if(counter == 2) {
		rects[2] = vec2(cos(time),sin(time));
	}
}

void main( void ) {
	if (sin(time/(2.0 * PI)) == 0.0 && gl_FragCoord.xy == vec2(0,0)) {
		updateRects();	
	}
	
	vec3 pos = vec3(screenToWorldCoord(gl_FragCoord.xy),1);
	
	float dy = cos(time * 0.5);
	
	mat3 transform = mat3(
   		sin(time * (2.0 * PI) * bpm), 0, 0, // first column (not row!)
   		0, height, 0, // second column
		horizSpeed, dy, 1  // third column
   		);
	
	pos = transform * pos;
	
	float d1 = rect(pos.xy - vec2(-0.3,0.0), vec2(0.1, 0.2), (cos(time / 2.0) + 1.0) * 0.3); 
	vec3 clr1 = vec3(rects[0].x, rects[0].y, 1.0) *d1;
	
	
	float d2 = rect(pos.xy - vec2(0.0,0.0), vec2(0.1, 1.0 * sin(time / 2.0)), 0.1); 
	vec3 clr2 = vec3(0.6,0.99,0.2) *d2; 

	
	float d3 = rect(pos.xy - vec2(1.0,0.0),vec2(1,0.1), 0.1);
	vec3 clr3 = vec3(1.0,1.0,1.0)*d3;
	
	float d4 = rect(pos.xy - vec2(0.5,spinner),vec2(1,0.1), 0.1);
	vec3 clr4 = vec3(1.0,1.0,1.0)*d4;
	
	float d5 = rect(pos.xy - vec2(1.0,1.0),vec2(1,0.1), 0.1);
	if (sin(time) > 0.5 || sin(time) < -0.5) {
		d5 = rect(pos.xy - vec2(1.0,sin(time)),vec2(1,0.1), 0.1);
	}
	
	vec3 clr5 = vec3(1.0, 1.0, 1.0) * d5;
	
	if (cos(time) > 0.5) {
	    clr5 = vec3(1.0, 1.0, 0.10) * d5;
	}
	
	vec3 clr = clr1+clr2+clr3 + clr4 + clr5;
	gl_FragColor = vec4( clr , 1.0 );
}