// Posted by Trisomie21

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float nrand(vec2 n) { return fract(sin(dot(n.xy, vec2(12.9898, 78.233))) * 43758.5453); }

void main(void) {

	vec2 screen_pos = gl_FragCoord.xy;
	
	vec2 emitter0 = resolution*.5 + vec2(sin(time*.3), cos(time*.7))*20.0;
	vec2 emitter1 = resolution*.5 + vec2(sin(time*.11), cos(time*.13))*200.0;
	vec2 emitter2 = resolution*.5 + vec2(sin(time*.5), cos(time*.3))*50.0;
	
	vec2 v0 = screen_pos - emitter0;
	vec2 v1 = screen_pos - emitter1;
	vec2 v2 = screen_pos - emitter2;
	
	float color = nrand(screen_pos*0.01 + time*0.01);
	
	float s = 0.0;
	
	if(length(v0) > 4.0 && length(v1) > 4.0 && length(v2) > 4.0)
	{
		vec2 y = normalize(-v0);
		vec2 x = vec2(-y.y, y.x);
		float d = length(y);
		float r = color*d*10.0;
		float l = length(v0) / 200.0;
		y *= r;
		x *= r;

		vec2 y2 = normalize(-v1);
		vec2 x2 = vec2(-y2.y, y2.x);
		float d2 = length(y2);
		float r2 = color*d2*10.0;
		float l2 = length(v1) / 200.0;
		y2 *= r2;
		x2 *= r2;
		
		vec2 y3 = normalize(-v2);
		vec2 x3 = vec2(-y3.y, y3.x);
		float d3 = length(y3);
		float r3 = color*d3*10.0;
		float l3 = length(v2) / 200.0;
		y3 *= r3;
		x3 *= r3;		
		s = min(min(l , l2),l3);
		
		float m = clamp((l-l2) + 0.5, 0.0 , 1.0);
		float m2 = clamp((l-l3) + 0.5, 0.0 , 1.0);
		y = mix(mix(y, y2, m),y3,m2);
		x = mix(mix(x, x2, m),x3,m2);
	
		color = texture2D(backbuffer, (screen_pos + y*.2)/resolution).x*.4 +
			texture2D(backbuffer, (screen_pos + y - x*.2)/resolution).x*.6 - .005;
	}
	
	s = clamp(s*2.0, 0.0, 2.0);
	gl_FragColor = vec4(color, color*s, color*s, 1.0 );
}