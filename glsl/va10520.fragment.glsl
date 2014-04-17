#ifdef GL_ES
precision mediump float;
#endif

// Posted by Trisomie21

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

#define LAYERS 5.0

float rand(vec2 co){ return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453); }

void main( void ) {
	
	vec2 pos = gl_FragCoord.xy - resolution.xy * mouse;
	float dist = length(pos) / resolution.y;
	vec2 coord = vec2(dist, atan(pos.x, pos.y) / (3.1415926*2.0));
	
	vec3 color = vec3(0.0);
	for (float i = 0.0; i < LAYERS; ++i)
	{
		float t = i*100.0+time*.2*(i*i);
		
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
		vec3 m = fract(r*100.0 * vec3(1.0, 1.0, 1.0))*.8+i*.2;
		
		// Mask cell
		p = floor(p*100.0);
		float d = (rand(p)-0.6)*10.0;
		d = clamp(d, 0.0, 1.0);
	
		color = max(color, a*m*d);
	}

	gl_FragColor =  vec4(color, 1.0 );
	
	{
	vec2 uv = gl_FragCoord.xy / resolution.xy;		
	vec2 d = 40./resolution; //liquidy
	float dx = texture2D(backbuffer, uv + vec2(-1.,0.)*d).x - texture2D(backbuffer, uv + vec2(1.,0.)*d).x ;
	float dy = texture2D(backbuffer, uv + vec2(0.,-1.)*d).x - texture2D(backbuffer, uv + vec2(0.,1.)*d).x ;
	d = vec2(dx,dy)*resolution/1024.;
	gl_FragColor.z = pow(clamp(1.-1.5*length(uv  - vec2(.4,.6) + d*2.0),0.,1.),4.0);
	gl_FragColor.y = gl_FragColor.z*0.5 + gl_FragColor.x*0.4;
	}	
}