// Posted by Trisomie21

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

const float Emitter1Force = 10.0;
const float Emitter2Force = 15.0;

float nrand(vec2 n) { return fract(sin(dot(n.xy, vec2(12.9898, 78.233))) * 43758.5453); }

void main(void) {

	vec2 screen_pos = gl_FragCoord.xy;
	
	vec2 emitter0 = resolution*.5 + vec2(sin(time*.5), cos(time*.6))*20.0;
	vec2 emitter1 = resolution*.5 + vec2(sin(time*.6), cos(time*.5))*200.0;
	
	vec2 v0 = screen_pos - emitter0;
	vec2 v1 = screen_pos - emitter1;
	
	float color = nrand(screen_pos*0.01 + time*0.01);
	
	float s = 0.0;
	
	if(length(v0) > 4.0 && length(v1) > 4.0)
	{
		vec2 y = normalize(-v0);
		vec2 x = vec2(-y.y, y.x);
		float d = length(y);
		float r = color*d*Emitter1Force;
		float l = length(v0) / 300.0;
		y *= r;
		x *= r;

		vec2 y2 = normalize(-v1);
		vec2 x2 = vec2(-y2.y, y2.x);
		float d2 = length(y2);
		float r2 = color*d2*Emitter2Force;
		float l2 = length(v1) / 300.0;
		y2 *= r2;
		x2 *= r2;
		
		s = min(l , l2);
		
		float m = clamp((l-l2) + 0.5, 0.0 , 1.0);
		y = mix(y, y2, m);
		x = mix(x, x2, m);
	
		color = texture2D(backbuffer, (screen_pos + y*.2)/resolution).x*.4 +
			texture2D(backbuffer, (screen_pos + y - x*.2)/resolution).x*.6 - .005;
	}
	
	s = clamp(s*2.0, 0.0, 2.0);
	gl_FragColor = vec4(color, color-.4, color*s, 1.0 );
}