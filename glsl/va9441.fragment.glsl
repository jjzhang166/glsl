#ifdef GL_ES
precision mediump float;
#endif

#ifdef title 
Aurora borealis by guti
#endif
	
#ifdef author
guti
#endif
	
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

const float pi = 3.141516;

vec3 rgbFromHue(in float h) {
	h = fract(h)*4.0001;
	
	float c0 = clamp(h,0.0,1.0);
	float c1 = clamp(h-1.0,0.0,1.0);
	float c2 = clamp(h-2.0,0.0,1.0);
	float c3 = clamp(h-3.0,0.0,1.0);
	
	
	float r = (1.0 - c1);
	float g = c0 - c3;
	float b = c2;
	
	return vec3(r,g,b);
}

void main( void ) {
	vec2 x1=vec2(1.0*resolution.x,0.0*resolution.y);
	vec2 x2=vec2(0.0*resolution.x,0.0*resolution.y);
	vec2 x3=vec2(1.0*resolution.x,1.0*resolution.y);
	vec2 x4=vec2(0.0*resolution.x,1.0*resolution.y);
	
	float d1=length(x1-gl_FragCoord.xy);
	float d2=length(x2-gl_FragCoord.xy);
	float d3=length(x3-gl_FragCoord.xy);
	float d4=length(x4-gl_FragCoord.xy);
	
	float value1=0.9;
	float value2=0.9;
	float value3=0.1;
	float value4=0.0;
	
	float maxdist=d1+d2+d3+d4;
	
	
	float dist1=((maxdist-d1)/maxdist);
	
	float dist2=((maxdist-d2)/maxdist);
	
	float dist3=((maxdist-d3)/maxdist);
	
	float dist4=((maxdist-d4)/maxdist);
	
	float endvalue =(value1*dist1)+(value2*dist2)+(value3*dist3)+(value4*dist4);
	
	
	gl_FragColor = vec4(rgbFromHue(endvalue),1.0);
	
	
}

