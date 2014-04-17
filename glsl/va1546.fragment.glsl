#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand (float x) {
	return fract(sin(x * 24614.63) * 36817.342);	
}
float sphere(vec2 c, vec2 s)
{
	return pow(max(80.5 - distance(c, s), 0.0), 2.0);	
}
float recursisphere2(vec2 p, vec2 c, float d)
{
	float ma = 0.0;
	ma += sphere(p, vec2(c.x , c.y));
	ma += sphere(p, vec2(c.x , c.y + sin(time) * d));
	ma += sphere(p, vec2(c.x  + sin(time) * d, c.y));
	ma += sphere(p, vec2(c.x, c.y  - sin(time) * d));
	ma += sphere(p, vec2(c.x - sin(time) * d, c.y ));
	ma -= sphere(p, vec2(c.x, c.y ));
	return ma;
}
float recursisphere(vec2 p, vec2 c, float d)
{
	float ma = 0.0;
	ma += sphere(p, vec2(c.x / 2.0, c.y / 2.0));
	ma += recursisphere2(p, vec2(c.x / 2.0, c.y / 2.0 + sin(time) * d), 120.0 + sin(time * 0.13) * 50.0);
	ma += recursisphere2(p, vec2(c.x / 2.0 + sin(time) * d, c.y / 2.0), 90.0 + sin(time * 0.25) * 50.0);
	ma += recursisphere2(p, vec2(c.x / 2.0, c.y / 2.0 - sin(time) * d), 70.0 + sin(time * 0.37) * 50.0);
	ma += recursisphere2(p, vec2(c.x / 2.0 - sin(time) * d, c.y / 2.0), 30.0 + sin(time * 0.41) * 50.0);
	ma -= sphere(p, vec2(c.x / 2.0, c.y / 2.0));
	return ma;
}
void main( void ) {

	vec2 position = ( gl_FragCoord.xy / 2.0 );
	float ma = 0.0;
	
	ma += sphere(position, vec2(resolution.x / 4.0, resolution.y / 4.0));
	ma += recursisphere(position, vec2(resolution.x / 2.0, resolution.y / 2.0 + sin(time) * 50.0), 180.0 + sin(time * 0.45) * 50.0);
	ma += recursisphere(position, vec2(resolution.x / 2.0 + sin(time) * 50.0, resolution.y / 2.0), 70.0 + sin(time * 0.13) * 50.0);
	ma += recursisphere(position, vec2(resolution.x / 2.0, resolution.y / 2.0 - sin(time) * 50.0), 280.0 + sin(time * 0.36) * 50.0);
	ma += recursisphere(position, vec2(resolution.x / 2.0 - sin(time) * 50.0, resolution.y / 2.0), 80.0 + sin(time * 0.15) * 50.0);
	ma -= sphere(position, vec2(resolution.x / 4.0, resolution.y / 4.0));
	
	float e = ma > 4200.5 ? 1.0 : (ma > 3000.5 ? 0.7 : (ma > 0.5 ? 0.1 : 0.2));
	gl_FragColor = vec4(e, e, e, 1.0);

}