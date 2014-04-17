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

/* public domain */
vec3 rgbFromHue(in float h) {
	
	const float K = 1.0/6.0;

	h = h - floor(h);
	float r = smoothstep( 2.0*K, 1.3*K, h) + smoothstep( 4.0*K, 5.0*K, h);
	float g = smoothstep( 0.0*K, 1.0*K, h) - smoothstep( 3.0*K, 4.0*K, h);
	float b = smoothstep( 2.0*K, 3.0*K, h) - smoothstep( 5.0*K, 6.0*K, h);
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
}
