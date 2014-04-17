// by rotwang, some scrolling shapes for Krysler
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float Krysler_620(vec2 p) {

	float shade = 1.0/( sin( p.x + time ) - abs(p.y) );
	shade = sqrt(shade) / 3.0;

	return shade;
}

vec3 Krysler_620_clr(vec2 p) {

	float shade = Krysler_620(p);
	vec3 clr_a = vec3(shade*0.2, shade*0.26, shade);
	vec3 clr_b = vec3(shade*0.7, shade*0.5, shade*0.6);
	vec3 clr = clr_a*p.y*0.5; //  + clr_b*(1.0-p.y)*0.25;
	
	clr += clr_b*(2.0-p.y);
	return clr;
}

void main( void ) {

	float aspect = resolution.x / resolution.y;
	vec2 unipos = ( gl_FragCoord.xy / resolution );
 	vec2 pos = unipos*2.0-1.0;//bipolar
	pos.x *= .5*aspect * sin(time);

	vec3 clr = Krysler_620_clr(pos*3.0);
	clr -= Krysler_620_clr(pos*1.20);
	clr *= Krysler_620_clr(1.2+pos*3.20);
	clr += Krysler_620_clr(3.2+pos*.50);

	
	gl_FragColor = vec4(clr,  1.0);
}