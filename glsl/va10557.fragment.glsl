#ifdef GL_ES
precision mediump float;
#endif

// Posted by Trisomie21
// Some refactoring by emackey

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define LAYERS 5.0

float rand(vec2 co){ return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453); }

float bubbleAt(vec2 pos) {
	float dist = length(pos) / resolution.y;
	vec2 coord = vec2(dist, atan(pos.x, pos.y) / (3.1415926*2.0));
	
	float bubble = 0.0;
	for (float i = 0.0; i < LAYERS; ++i)
	{
		float t = i*100.0+time*(i*i);
		
		vec2 uv = coord;
		
		uv.y += (i*.1)*(i*.02);
		uv.y = fract(uv.y);
		
		float r = pow(uv.x, .1) - (t*.001);
		
		vec2 p = vec2(r, uv.y*.5);
		
		// UV coord in cell
		uv.x = mod(r, 0.01)/.01;
		uv.y = mod(uv.y, 0.02)/.02;
	
		// Shape
		float a = 1.0-length(uv*2.0-1.0);
	
		// Color
		float m = fract(r*100.0 * 1.0)*.8+i*.2;
		
		// Mask cell
		p = floor(p*100.0);
		float d = (rand(p)-0.6)*10.0;
		d = clamp(d, 0.0, 1.0);
	
		bubble = max(bubble, a*m*d);
	}
	return bubble;
}

void main( void ) {
	
	vec2 pos = gl_FragCoord.xy - resolution.xy * mouse;
	
	float bubble = bubbleAt(pos);
	
	vec2 uv = gl_FragCoord.xy / resolution.xy;		
	const float d = 4.0;
	float dx = bubbleAt(vec2(pos.x - d, pos.y)) - bubbleAt(vec2(pos.x + d, pos.y));
	float dy = bubbleAt(vec2(pos.x, pos.y - d)) - bubbleAt(vec2(pos.x, pos.y + d));
	vec2 dd = vec2(dx,dy)*resolution/1024.;
	float background = pow(clamp(1.-1.5*length(uv  - vec2(.4,.6) + dd*2.0),0.,1.),4.0);
	
	vec3 bubbleColor = bubble * vec3(1.0, 0.4, 0.0);
	vec3 backgroundColor = background * vec3(0.0, 0.5, 1.0);
	
	gl_FragColor = vec4((bubbleColor + backgroundColor)*length(((uv-(mouse-0.5))*2.0)-1.0), 1.0);
}