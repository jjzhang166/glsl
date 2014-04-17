#ifdef GL_ES
precision mediump float;
#endif

uniform vec2  resolution;
uniform float time;
uniform vec2 mouse;
const int num = 8;
const float PI = 3.141592;
uniform sampler2D  backbuffer; 


void main() {
	float color;
	float r = sqrt(pow(( mouse.x*resolution.x -resolution.x/2.0), 2.0) + pow((resolution.y/2.0 - mouse.y*resolution.y), 2.0));
	vec2 texPos;
	vec2 ballPos;
	
	for (int j = 0; j < num; ++j) {
		float x =  resolution.x*mouse.x + r*(cos(float(j)/float(num) *(2.0*PI) + 3.6*sin(time/4.0) ));
		float y =  resolution.y*mouse.y + r*(sin(float(j)/float(num) *(2.0*PI) + 7.2*sin(time/4.0) ));
		float size = 2.0 - 0.2 * sin(time);
		ballPos = vec2(x, y);
		float dist = length(gl_FragCoord.xy - ballPos);
		color += pow(size/dist, 2.0);
		texPos = vec2(gl_FragCoord.xy/resolution);
	}
	
	
	vec4 shadow = vec4(texture2D(backbuffer, texPos).r*0.94,texture2D(backbuffer, texPos).gba*0.89);
	gl_FragColor = shadow + color;
	
}
