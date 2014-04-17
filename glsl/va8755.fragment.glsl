#ifdef GL_ES
precision mediump float;
#endif
 
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 digit(vec2 pos, int d) {
	float b = length(max(abs(pos-vec2(0.5))-vec2(0.4), 0.0))-0.09;
	if(b > 0.0) return vec3(0.0);
	
	// need some prettier numbers..
	bool on = false;
	vec2 ipos = 2.0 * pos - vec2(1.0);
	{
		float x = pos.x, y = pos.y;
		bool s1 = (x > 0.15) && (x < 0.25) && ( y > 0.55 ) && ( y < 0.80 );
		bool s2 = (x > 0.15) && (x < 0.25) && ( y < 0.45 ) && ( y > 0.20 );
		bool s3 = (x > 0.75) && (x < 0.85) && ( y > 0.55 ) && ( y < 0.80 );
		bool s4 = (x > 0.75) && (x < 0.85) && ( y < 0.45 ) && ( y > 0.20 );
		bool s5 = (y > 0.10) && (y < 0.20) && ( x > 0.25 ) && ( x < 0.75 );
		bool s6 = (y > 0.45) && (y < 0.55) && ( x > 0.25 ) && ( x < 0.75 );
		bool s7 = (y > 0.80) && (y < 0.90) && ( x > 0.25 ) && ( x < 0.75 );
		s1 = s1 && (d==0||d==4||d==5||d==6||d==8||d==9);
		s2 = s2 && (d==0||d==2||d==6||d==8);
		s3 = s3 && (d!=5&&d!=6);
		s4 = s4 && (d!=2);
		s5 = s5 && (d!=1&&d!=4&&d!=7);
		s6 = s6 && (d!=0&&d!=1&&d!=7);
		s7 = s7 && (d!=1&&d!=4);
		on = s1 || s2 || s3 || s4 || s5 || s6 || s7;
	}
	return on ? vec3(0.9, 0.9, 0.0) : vec3(0.4);
}

vec3 fdigit(vec2 pos, float d, int m) {
	int t = int(d);
	float f = fract(d);
	float yf = (1.0+cos(f*3.14159))*0.5;
	float g = 1.0;
	if(pos.y > 0.5) {
		if(pos.y > yf) {
			t = t+1;
			if(t==m) t = 0;
		} else {	
			pos.y = 0.5 + (pos.y-0.5)*0.5/(yf-0.5);
			g = abs(0.5-yf)*2.0;
		}
	} else {
		if(pos.y >= yf) {
			pos.y = 0.5 - (0.5-pos.y)*0.5/(0.5-yf);
			g = abs(0.5-yf)*2.0;
			t = t+1;
			if(t==m) t = 0;
		}
	}
	return digit(pos, t) * g;
}


void main(void)
{
	vec2 position = gl_FragCoord.xy / resolution.y;

	vec2 rect_st = (position - vec2(0.35, 0.3)) * vec2(4.0, 3.0);
	vec2 rect_s = (position - vec2(0.6, 0.3)) * vec2(4.0, 3.0);
	vec2 rect_mst = (position - vec2(0.95, 0.3)) * vec2(4.0, 3.0);
	vec2 rect_ms = (position - vec2(1.2, 0.3)) * vec2(4.0, 3.0);

	float d_s  = mod(time, 10.0);
	float d_st = mod(time * 0.1, 6.0);
	float d_m  = mod(time / 60.0, 10.0);
	float d_mt  = mod(time / 600.0, 6.0);
	
	float t = fract(d_s);
	d_st = floor(d_st) + ((d_s  > 9.0)?t:0.0);
	d_m  = floor(d_m)  + ((d_st > 5.0)?t:0.0);
	d_mt = floor(d_mt) + ((d_m > 9.0)?t:0.0);
	
	vec3 color = 
		fdigit(rect_st,  d_mt, 6) +
		fdigit(rect_s,   d_m, 10) +
		fdigit(rect_mst, d_st, 6) +
		fdigit(rect_ms,  d_s, 10);
	gl_FragColor = vec4(color, 1.0);
}