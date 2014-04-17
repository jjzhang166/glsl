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
	for (float i=3.0; i<6.0; i++) {
		
		float ck1 = sin(time*i*0.5);
		float ck2 = cos(time*i*0.987*0.25);
		float ck3 = sin(time*i*1.24*0.5);
		float ck4 = cos(time*i*2.97*0.25);
			
		float keyShift = i*invN*time*0.5*sign;
		sign = -sign;
		
		float k  = ck1 * sin(angle*2.0*2.0+time*0.25) + 
			   ck2 * sin(angle*3.0*2.0+time*0.25) + 
			   ck3 * sin(angle*6.0*2.0+time*0.5) + 
			   ck4 * sin(angle*1.0*2.0+time*0.25);
		
		float k2 = (i+0.5)*invN + k*0.1;
		
		if (dist < k2) {
			gl_FragColor += vec4( rgbFromHue(i*angle/pi+keyShift)*(1.0+(dist*0.95-k2)*3.0), 1.0 )*0.075*(1.5-dist);
			return;
		}
	}
	
	if (gl_FragCoord.y < 10.0){
		
	gl_FragColor = vec4(rgbFromHue(gl_FragCoord.x/resolution.x),1.0);
	}
}

