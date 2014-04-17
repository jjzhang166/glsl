#ifdef GL_ES
precision mediump float;
#endif
#define M_PI 3.1415926535897932384626433832795
uniform float time;
uniform vec2 resolution;
float post_process(float color) {
	float m = mod(color, 2.0);
	if (m >= 1.0)
		color = 2.0 - m;
	else
		color = m;
	return color;
}
void main( void ) {
vec2 p = ( gl_FragCoord.xy ) / 8.0 ;
vec3 color = vec3(0.0);
	float r = 0.5;
	float g = 0.0;
	float b = 0.0;
	float step1 = 1.2;
	float step2 = 1.2;
	float step3 = 1.2;
	float a =0.;
	float mod = sin(time * .012) * M_PI;
		float t =0.;
		float i = 0.;
		a = 0.;
		t = cos(p.x + time ) / 2.0;
		r += t  ;
		g += t ;
		b += t  ;
		i=1.0;
		a = 2.0 * mod / step1;
		t = cos((p.x * cos(a) + p.y * sin(a)) + time ) / 2.0;
		r += t   ;
		g += t   ;
		b += t   ;
		i=2.0;
		a = i * (2.0 * mod / step2);
		t = cos((p.x * cos(a) + p.y * sin(a)) + time ) / 2.0;
		r += t +   i;
		g += t +   i;
		b += t +   i;
		i=3.0;
		a = i * (2.0 * mod / step3);
		t = cos((p.x * cos(a) + p.y * sin(a)) + time ) / 2.0;
		r += t +   i;
		g += t +  i;
		b += t + i;
		//i=4.0;
		//a = i * (2.0 * M_PI / 5.);
		//t = cos((p.x * cos(a) + p.y * sin(a)) + time ) / 2.0;
		//r += t + 0.1 + 0.1 * i;
		//g += t + 0.1 + 0.1 * i;
		//b += t + 0.1 + 0.1 * i;
		r = post_process(r);
		g = post_process(g);
		b = post_process(b);
	gl_FragColor = vec4( r, g, b, 1.0 )+vec4(0.25,0.4,0.5,1.0);}