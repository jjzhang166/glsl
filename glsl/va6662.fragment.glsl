// schmid

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float svin(float p) { return sin(p*6.28) * 0.5 + 0.5; }

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );// + mouse / 4.0;
	vec2 pc = position * 2.0 - vec2(1.0, 1.0);
	vec2 pc2 = position * 2.0 - vec2(1.08, 1.0);
	vec2 pc3 = position * 2.0 - vec2(0.92, 1.0);
	
	float r = sqrt(dot(pc, pc));
	float r1 = sqrt(dot(pc2, pc2));
	float r2 = sqrt(dot(pc3, pc3));
	float a = atan(pc.y,pc.x) / 6.28;
	float a1 = atan(pc2.y,pc2.x) / 6.28;
	float a2 = atan(pc3.y,pc3.x) / 6.28;
	
	float s = 0.1;
	gl_FragColor = vec4( floor(r+
				   svin(a*12.0+s*time*0.09)*0.3+
				   svin(a*14.0+s*time*0.11)*0.1+
				   svin(a*16.0-s*time*0.1)*0.2) * 0.9
			    - floor(r1*0.88+
				   svin(a1*13.0+s*time*0.07)*0.3+
				   svin(a1*15.0+s*time*0.12)*0.1+
				   svin(a1*17.0-s*time*0.13)*0.2) * 0.8
			    + floor(r2*0.8+
				   svin(a2*23.0+s*time*0.08)*0.3+
				   svin(a2*25.0+s*time*0.10)*0.1+
				   svin(a2*27.0-s*time*0.14)*0.2) * 0.9
			    - floor(r*0.86+
				   svin(a*23.0+s*time*0.08)*0.3+
				   svin(a*25.0+s*time*0.10)*0.1+
				   svin(a*27.0-s*time*0.14)*0.2) * 0.5
			    , 0.0, 0.0, 1.0 );
}