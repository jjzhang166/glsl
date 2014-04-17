#ifdef GL_ES
precision mediump float;
#endif

uniform vec2  resolution;
uniform float time;
uniform vec2 mouse;
const int num = 5;
const float PI = 3.141592;
uniform sampler2D  backbuffer; 


void main() {
	float color;
	float r = sqrt(pow(( 0.8*resolution.x -resolution.x/2.0), 1.0) + pow((resolution.y/2.0 - 0.4*resolution.y), 1.7));
	vec2 texPos;
	vec2 ballPos;
	
	for (int j = 0; j < num; ++j) {
		float x =  resolution.x*0.5 + r*(cos(float(j)/float(num) *(2.0*PI) + 1.0*1.0*time*5.0 ));
		float y =  resolution.y*0.5 + r*(sin(float(j)/float(num) *(2.0*PI) + 1.0*1.0*time*5.0 ));
		float size = 0.5 - 0.3 * sin(time*1.0);
		ballPos = vec2(x, y);
		float dist = length(gl_FragCoord.xy - ballPos);
		color += pow(size/dist, 1.2);
		texPos = vec2(gl_FragCoord.xy/resolution);
	}
	
	
	vec4 shadow = vec4(texture2D(backbuffer, texPos).r*0.94,texture2D(backbuffer, texPos).gba*0.85);
	gl_FragColor = shadow + color * vec4(0.0, 0.0, 1.0, 0.5);
	
}
