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
	h = fract(h)*6.0;
	
	float c0 = clamp(h,0.0,1.0);
	float c1 = clamp(h-1.0,0.0,1.0);
	float c2 = clamp(h-2.0,0.0,1.0);
	float c3 = clamp(h-3.0,0.0,1.0);
	float c4 = clamp(h-4.0,0.0,1.0);
	float c5 = clamp(h-5.0,0.0,1.0);
	
	float r = (1.0 - c1) + c4;
	float g = c0 - c3;
	float b = c2 - c5;
	
	return vec3(r,g,b);
}

void main( void ) {
	vec2 v = (gl_FragCoord.xy - resolution/2.0) / min(resolution.y,resolution.x) * 2.0;
	
	const float N = 5.0;
	const float invN = 1.0/N;
	float angle;
	float sign;
	float tfactor;
	
	angle = atan(v.x/v.y);
	sign = 1.0;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	vec3 color;
	float sr = 5.0*resolution.x/1280.0;
	color =( texture2D(backbuffer, gl_FragCoord.xy/resolution).rgb +
		 texture2D(backbuffer, vec2(gl_FragCoord.x-sr*v.x * .5, gl_FragCoord.y)/resolution).rgb +
		 texture2D(backbuffer, vec2(gl_FragCoord.x-sr*v.x, gl_FragCoord.y)/resolution).rgb +
		 texture2D(backbuffer, vec2(gl_FragCoord.x, gl_FragCoord.y-sr*v.y *.5)/resolution).rgb +
		 texture2D(backbuffer, vec2(gl_FragCoord.x, gl_FragCoord.y-sr*v.y)/resolution).rgb)*0.2;
	
	
	gl_FragColor = vec4( color*0.95, 1.0 );
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	float dist = length(v);
	
	
	if (gl_FragCoord.y < 10.0){
		
	gl_FragColor = vec4(rgbFromHue(gl_FragCoord.x/resolution.x),1.0);
	}
}

