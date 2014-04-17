// Eldritch Conundrum
#ifdef GL_ES
precision mediump float;
#endif
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
#define lol
#define pi 3.1415926535897932384626433832795028841971693993751 lol
float _pow(float x, float y) { return pow(abs(x), y); }
float _sin(float x) { return (x < 0.0) ? 0.0 : sin(x); }
float _cos(float x) { return (x < 0.0) ? 0.0 : cos(x); }
float _sqrt(float x) { return sqrt(abs(x)); }

vec3 orange_laser2(float f)	{ return (vec3(1.3,0.7,0.2)) / _pow(0.9 + abs(f)*2.0, 1.1); }
vec3 orange_laser(float f)	{ return (vec3(1.3,0.7,0.2)) / _pow(0.9 + abs(f)*80.0, 1.1); }
vec3 blue_laser(float f)	{ return (vec3(0.5,0.5,1.25)) / _pow(0.5 + abs(f)*40.0, 1.1); }
vec3 faint_blue_laser(float f)	{ return (vec3(0.5,0.5,1.25)) / _pow(1.6 + abs(f)*80.0, 1.1); }
vec3 red_laser(float f)		{ return (vec3(1.25,0.5,0.5)) / _pow(0.0 + abs(f)*60.0, 1.3); }
vec3 green_laser(float f)	{ return (vec3(0.5,1.25,0.5)) / _pow(0.0 + abs(f)*80.0, 1.1); }
vec3 violet_laser(float f)	{ return (vec3(1.25,0.5,1.25)) / _pow(0.0 + abs(f)*80.0, 1.1); }
vec3 cyan_laser(float f)	{ return (vec3(0.5,1.25,1.25)) / _pow(0.0 + abs(f)*80.0, 1.1); }
vec3 _main() {
	vec3 res = vec3(0,0,0);
	float rtime=time*0.5;
	vec2 p = gl_FragCoord.xy / resolution.xx;
	p -= vec2(0.5, 0.5 * resolution.y/resolution.x); // shift origin to center
	p *= 15.; // zoom out
	
	// grid
	//res += blue_laser(abs(p.x)); res += blue_laser(abs(p.y));
	//res += faint_blue_laser(abs(sin(p.x*pi))); res += faint_blue_laser(abs(sin(p.y*pi)));


	//res += orange_laser((sin(p.x)-p.y) / 15.0);
	//res += sqrt(blue_laser(p.x*_pow(sin(p.x)*cos(p.x),0.9)-p.y));
	
	/*return green_laser((tan(cos(p.x)*sin(p.y)*110.0*
			abs(1.0-abs(sin(rtime)+0.7)*0.7)
		       )) / 5.0);*/
	
	//light saber duel
	//res += red_laser((cross(p.xyy, vec3(sin(rtime), cos(rtime), tan(rtime))).y) / 20.0);
	//res += green_laser((cross(p.xyy, vec3(sin(-rtime), cos(rtime), tan(rtime))).y) / 20.0);
	
	
	if (true)
	{
		// blue balls
		float sum = 0.0;
		for (float i = 0.0; i <= 100.0; i +=pi*0.31){
			float t = i * (1.0 + 0.08*sin(0.2*rtime));
			float f = distance(p, 0.1*vec2(t * cos(t-rtime*0.2), t * sin(t-rtime*0.2)));
			sum += 1.0/_pow(f, 2.0);
		}
		res.rgb += cos(rtime) * faint_blue_laser((5.0-sum*0.2) / 50.0);
	}

	// cyan target
	if (true)
	if (sin(rtime)>0.0)
		res.rgb += sin(rtime) * cyan_laser((p.x*sin(3.*p.x)-p.y*sin(3.*p.y)) / 2.0);
	
	// orange balls
	if (true)
	res.rgb += -sin(rtime) * orange_laser2(1.9*sin(rtime*0.9)+p.x*sin(10.0*p.x)+p.y*cos(10.0*p.y));

	// green stuff
	if (true)
	if (-cos(rtime)>0.0)
	{
		if (sin(rtime/2.0)>0.0) {
			res.rgb += -cos(rtime) * green_laser((tan(p.x*p.y*100.0*(sin(rtime)*0.3+0.1))) / 5.0);
		} else {
			float sx=p.y*3.0;float sy=p.x*3.0;
			res += -cos(rtime) * green_laser((
				cos(sy*abs(0.24*(sin(time)+2.02)))*cos(sx)-cos(sy)*cos(0.8*sy)
			) / 5.0);
		}
	}
			
	// 2 curved violet lasers
	if (true)
	res.rgb += violet_laser((distance(p, vec2(0.0)) - sin(0.1+0.5*rtime)*_pow(p.x, 1.05)) / 2.0);
	
	// 4 red circles
	if (true)
	res.rgb += 
		red_laser((distance(p, vec2(0.0)) - _pow(_sin(0.9+0.25*time), 3.0)*_sqrt(p.y-p.x)) / 2.0) +
		red_laser((distance(p, vec2(0.0)) - _pow(_sin(0.9+0.25*time), 3.0)*_sqrt(p.y+p.x)) / 1.0);
	return res;
}
void main() { gl_FragColor.rgb = _main(); }
lol