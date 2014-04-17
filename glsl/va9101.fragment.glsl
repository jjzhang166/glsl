#ifdef GL_ES
precision mediump float;
#endif

/* fragment fun by guti */

uniform float time;
uniform vec2  resolution;

#define K  (1.0/6.0)
#define K2 (20.0)
#define K3 (0.5/K2)

vec3 rgbFromHue(in float h) {
	h = h - floor(h);
	float r = smoothstep( 2.0*K, 1.3*K, h) + smoothstep( 4.0*K, 5.0*K, h);
	float g = smoothstep( 0.0*K, 1.0*K, h) - smoothstep( 3.0*K, 4.0*K, h);
	float b = smoothstep( 2.0*K, 3.0*K, h) - smoothstep( 5.0*K, 6.0*K, h);
	return vec3(r,g,b);
}

void main( void ) {
	vec2 rP = 2.0 * ( gl_FragCoord.xy / resolution.xy ) + vec2(-1.0,-1.0);
	rP *= vec2(resolution.x/resolution.y, 1.0);
	
	vec2 P0 = vec2(sin(time*2.0013),cos(time*0.5999))*0.5;
	vec2 P1 = vec2(cos(time*1.4011),sin(time*2.0007))*0.5;
	
	float d0 = distance(rP,P0);
	float d1 = distance(rP,P1);

	vec3 color =  vec3( rgbFromHue(2.0/d0 - 2.0/d1 + time) * smoothstep(10.01, 10.0, 1.0/d0 + 1.0/d1));
	
	float factor = resolution.x/K2;
	
	color.r *= color.r*0.5+mod(gl_FragCoord.y, factor * d0) * K3;
	color.g *= color.g*0.5+mod(gl_FragCoord.x, factor * d0) * K3;
	color.b *= color.b*0.5+mod(gl_FragCoord.y - gl_FragCoord.x, factor * d0) * K3;
	
        gl_FragColor = vec4(color, 1.0);
			
}