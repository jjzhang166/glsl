// by rotwang, some scrolling shapes for Krysler
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


vec3 waves(vec2 pos) {
	
	float shade = 1.0/( sin( pos.x + time )+sin(pos.x*5.0+time*10.0)*0.1 - pos.y );
	
	shade = pow(shade, 0.5)/3.0;
	
	vec3 clr_a = vec3(shade*0.2, shade*0.66, shade);
	vec3 clr_b = vec3(shade*0.2, shade*0.5, shade*0.6);
	vec3 clr = clr_a*pos.y*0.5; //  + clr_b*(1.0-p.y)*0.25;
	
	clr += clr_b*(1.0-pos.y);
	
	return clr;
}

float waves2(vec2 pos) {
	
	float shade = 1.0/( sin( pos.x + time )+sin(pos.x*5.0+time*10.0)*0.1 - pos.y );
	
	shade = pow(shade, 0.5)/3.0;
	
	
	return shade;
}

void main( void ) {

	float aspect = resolution.x / resolution.y;
	vec2 unipos = ( gl_FragCoord.xy / resolution );
 	vec2 pos = unipos*2.0-1.0;//bipolar
	pos.x *= aspect;

	vec3 clr = waves(pos*vec2(3.1415*0.3, cos(time)*2.0+4.0));
	clr += waves(pos*vec2(3.1415*0.5+sin(time*0.2), sin(time)*0.5+10.0))*0.5;
	
	float vignette = pow(1.0-abs(pos.x*0.4), 2.0);
	clr *= vignette;
	gl_FragColor = vec4(clr,  1.0);
}