#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// never watch into the sun ;)

#define BLADES 6.0
#define BIAS 0.1
#define SHARPNESS 3.0
#define COLOR 0.82, 0.65, 0.4
#define BG 0.34, 0.52, 0.76

void main( void ) {

	vec2 sunpos = (mouse - 0.5) / vec2(resolution.y/resolution.x,1.0);
	vec2 position = (( gl_FragCoord.xy / resolution.xy ) - vec2(0.5)) / vec2(resolution.y/resolution.x,1.0);
	vec2 t = position.yx - sunpos.yx;
	float alpha = sunpos.x * 0.5 + sin(time * 0.1) * 0.02;
	t = mat2(cos(alpha), -sin(alpha), sin(alpha), cos(alpha)) * t;
	
	float blade = clamp(pow(sin(atan(t.x, t.y)*BLADES)+BIAS, SHARPNESS), 0.0, 1.0);

	float dist = 1.0 / distance(sunpos, position) * 0.075;
	float dist2 = 2.0 - distance(vec2(0.0), sunpos);
	dist2 = pow(dist2, 3.0 + sin(time * 2.9) * sin(time * 4.9) * 0.2);
	dist *= dist2;

	vec3 color = vec3(0.0);
	color = mix(vec3(0.34, 0.5, 1.0), vec3(0.0, 0.5, 1.0), (position.y + 1.0) * 0.5);

	color += vec3(0.95, 0.65, 0.30) * dist;
	color += vec3(0.95, 0.45, 0.30) * min(1.0, blade *0.7) * dist;

	gl_FragColor = vec4( color, 1.0 );
}