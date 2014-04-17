#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

#define K (1.0/6.0)

vec3 rgbFromHue(float h) {
	
	h = h - floor(h);
	
	float r = smoothstep( 2.0*K, 1.3*K, h) + smoothstep( 4.0*K, 5.0*K, h);
	float g = smoothstep( 0.0*K, 1.0*K, h) - smoothstep( 3.0*K, 4.0*K, h);
	float b = smoothstep( 2.0*K, 3.0*K, h) - smoothstep( 5.0*K, 6.0*K, h);
	
	return vec3(r,g,b);
}

#define N 5.0
void main( void ) {

	float acc = 0.0;
	
	// Screen rectangle centered in quad (1.0,1.0,-1.0,-1.0);
	vec2 pos = 2.0 * ( gl_FragCoord.xy / resolution.xy ) + vec2(-1.0,-1.0);
	
	// Adjust Screen ratio
	pos *= vec2(resolution.x/resolution.y, 1.0);
	
	float r1=0.5;
	
	const float n = 8.0;
	const float ph = 3.14156492 * 2.0 / n;
		
	float cph = .0;
	float rm = 0.2;
	
	for (float i=0.0; i<n; i++) {
		
		cph += ph;
		rm = -rm;
		
		vec2 posS0 = vec2(sin(time+cph), cos(time+cph))*(r1+rm*sin(time*3.0));
		vec2 posS1 = vec2(sin(time*10.0+cph), cos(time*10.0+cph))*r1*0.35;
	
		acc += smoothstep(0.05,0.,distance(pos,posS0+posS1));
		acc += smoothstep(0.05,0.,distance(pos,posS0));
	}
	
	
	vec3 color;
	
	const float sr = 3.0;
	
	color =( texture2D(backbuffer, gl_FragCoord.xy/resolution).rgb +
		 texture2D(backbuffer, vec2(gl_FragCoord.x-sr*pos.x * .5, gl_FragCoord.y)/resolution).rgb +
		 texture2D(backbuffer, vec2(gl_FragCoord.x-sr*pos.x, gl_FragCoord.y)/resolution).rgb +
		 texture2D(backbuffer, vec2(gl_FragCoord.x, gl_FragCoord.y-sr*pos.y *.5)/resolution).rgb +
		 texture2D(backbuffer, vec2(gl_FragCoord.x, gl_FragCoord.y-sr*pos.y)/resolution).rgb)*0.2;
	
	
	gl_FragColor = vec4( clamp(acc,.0,1.0) * rgbFromHue( cos(pos.x+time)+sin(pos.y+time*1.013)) + clamp(1.0-acc,.0,1.0) * color*0.975, 1.0 );
}