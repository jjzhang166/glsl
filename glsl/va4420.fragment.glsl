// Eldritch Conundrum
#ifdef GL_ES
precision mediump float;
#endif
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
#define lol
#define pi 3.1415926535897932384626433832795028841971693993751 lol
#define tau (pi*2.0)

vec3 orange_laser2(float f)	{ return (vec3(1.3,0.7,0.2)) / pow(0.9 + abs(f)*2.0, 1.1); }
vec3 orange_laser(float f)	{ return (vec3(1.3,0.7,0.2)) / pow(0.9 + abs(f)*80.0, 1.1); }
vec3 blue_laser(float f)	{ return (vec3(0.5,0.5,1.25)) / pow(0.5 + abs(f)*40.0, 1.1); }
vec3 faint_blue_laser(float f)	{ return (vec3(0.5,0.5,1.25)) / pow(1.6 + abs(f)*80.0, 1.1); }
vec3 red_laser(float f)		{ return (vec3(1.25,0.5,0.5)) / pow(0.0 + abs(f)*60.0, 1.3); }
vec3 green_laser(float f)	{ return (vec3(0.5,1.25,0.5)) / pow(0.0 + abs(f)*80.0, 1.1); }
vec3 violet_laser(float f)	{ return (vec3(1.25,0.5,1.25)) / pow(0.0 + abs(f)*80.0, 1.1); }
vec3 cyan_laser(float f)	{ return (vec3(0.5,1.25,1.25)) / pow(0.0 + abs(f)*80.0, 1.1); }
void main() {
	float rtime=time*0.5;
	vec2 p = gl_FragCoord.xy / resolution.xx;
	p -= vec2(0.5, 0.5 * resolution.y/resolution.x); // shift origin to center
	p *= 15.; // zoom out
	
	// grid
	//gl_FragColor.rgb += blue_laser(abs(p.x)); gl_FragColor.rgb += blue_laser(abs(p.y));
	//gl_FragColor.rgb += faint_blue_laser(abs(sin(p.x*pi))); gl_FragColor.rgb += faint_blue_laser(abs(sin(p.y*pi)));

	float d = sqrt(p.x*p.x+p.y*p.y);
	gl_FragColor.rgb += orange_laser((d-5.0) / 5.0);
	gl_FragColor.rgb += orange_laser((d-4.0) / 3.0);
	gl_FragColor.rgb += orange_laser((d-2.5) / (2.0+2.0*cos(5.0*rtime)));
	float angle = sign(p.y)*acos(p.x/d);
	float a = angle-rtime*0.2;
	gl_FragColor.rgb += orange_laser((d-(4.0+1.0*pow(fract(cos(16.0*(angle+rtime*0.02))), 1.6))) / 1.0);
	gl_FragColor.rgb += orange_laser((d-(3.5+0.5*fract(12.0*a/tau))) / 0.5);
	gl_FragColor.rgb += orange_laser((d-(3.0+0.5*fract(12.0*a/tau))) / 0.5);
	gl_FragColor.rgb += orange_laser((d-(2.5+0.5*fract(12.0*a/tau))) / 0.5);
	gl_FragColor.rgb += orange_laser((d-(1.4+0.5*pow(cos(6.0*(angle-rtime*0.12)), 8.0))) / 1.0);
	gl_FragColor.rgb += orange_laser((d-(1.6+0.5*1.0/(1.0+pow(sin(6.0*(angle-rtime*0.12)), 8.0)))) / 1.0);
	
	gl_FragColor.rgb += orange_laser((d-(0.4+0.2*pow(cos(4.0*(angle-rtime*0.32)), 8.0))) / 1.0);
	gl_FragColor.rgb += orange_laser((d-(0.7+0.3*1.0/(1.0+pow(sin(4.0*(angle+rtime*0.32)), 8.0)))) / 1.0);

}
