// by rotwang: some tests with smooth shapes and clipping for Krysler

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.1415926535;
const float TWOPI = PI*2.0;

float speed = time *0.5;
	float aspect = resolution.x / resolution.y;
	vec2 unipos = ( gl_FragCoord.xy / resolution );
	vec2 pos = vec2( (unipos.x*2.0-1.0)*aspect, unipos.y*2.0-1.0);
	//pos.x *=aspect;

vec2 rotated(float a, float r) {
	
	return vec2(cos(a*TWOPI)*r, sin(a*TWOPI)*r);
}


float osc1 = sin(time);
float unosc1 = sin(time)*0.5+0.5;


float line(vec2 p, float t, float smooth)
{
	
	float radius = 0.1;
	

	vec2 a = vec2(0.0);
	vec2 b = rotated(t, 1.0);	
	vec2 pma = vec2(p-a);
	
	vec2 bma = vec2(b-a); 
	float slen = distance(a, b);
	float halflen = slen * 0.5;
	
	vec2 bmr = bma * vec2(-1.0, 1.0);
	
	float d0 = dot(pma, bmr);
	float d1 = dot(pma, bma);
	d0 = abs(d0);
	d1 = abs(d1- halflen);
	
	d0 = max(d0,0.0);
	d1 = max(d1 - halflen, 0.0);
	

	float len1 = length(vec2(d0, d1));
	
	float len =  smoothstep(len1-smooth, len1+smooth, radius);
	
	return len;
}

float cospix(float f)
{
	return	cos(pos.x*f*PI);
}

float cospiy(float f)
{
	return	cos(pos.y*f*PI);
}

float cospi_max(float f)
{
	return	max(cos(pos.x*f*PI),cos(pos.y*f*PI));
}

float cospi_min(float f)
{
	return	min(cos(pos.x*f*PI),cos(pos.y*f*PI));
}

float cospi_add(float f)
{
	return	cos(pos.x*f*PI) + cos(pos.y*f*PI);
}

float cospi_sub(float f)
{
	return	cos(pos.x*f*PI) - cos(pos.y*f*PI);
}

float cospi_mul(float f)
{
	return	cos(pos.x*f*PI) * cos(pos.y*f*PI);
}

float cospi_div(float f)
{
	return	cos(pos.x*f*PI) / cos(pos.y*f*PI);
}

float cospi_mul_div_max(float f)
{
	float a = cospi_mul(f);
	float b = cospi_div(f);
	return max(a,b);
}

float cospi_mul_div_sub(float f)
{
	float a = cospi_mul(f);
	float b = cospi_div(f);
	return a-b;
}


float clipx(float x)
{
	return	step(abs(pos.x), x);
}

float clipy(float y)
{
	return	step(abs(pos.y), y);
}

float clipxy(float a)
{
	return	step(abs(pos.x), a) * step(abs(pos.y), a);
}

float smooth_clipy(float a, float smooth)
{
	
	float ry = abs(pos.y);
	float sx = smoothstep( ry-smooth, ry+smooth, a);
	return sx;
}

float smooth_clipx(float a, float smooth)
{
	
	float rx = abs(pos.x);
	float sx = smoothstep( rx-smooth, rx+smooth, a);
	return sx;
}


float cospix_clipped(float f)
{
	float w = cospix(f); 
	w *= clipxy( 1.0/f );
	return	w;
}

float cospixy_smooth_clipped(float f,  float smooth)
{
	float wx = cospix(f); 
	wx *= smooth_clipy( 1.0/f , smooth);
	float wy = cospiy(f); 
	wy *= smooth_clipx( 1.0/f , smooth);
	
	float w = max(wx,wy);
	return	w;
}

float cospiy_clipped(float f)
{
	float w = cospiy(f); 
	w *= clipxy( 1.0/f );
	return	w;
}

float Krysler_344(vec2 p)
{
	
	p.y *= 64.0;
	float n = 2.0;
	float xx = pow(pow(p.x, n), n)*(p.y*0.25 + 2.0); 
	float yy = log(pow(p.y, n)) / n*0.15; 
	float w = 1.0-sqrt(xx-yy);

	return w;
	
}

float Krysler_351(vec2 p)
{
	p *=0.5;
	p.x = abs(p.x*2.0);
	p.y *= 4.0;
	float n = 4.0;
	float xx = pow(pow(p.x, n), n)*(p.y + 1.0); 
	float yy = pow(p.y*1.5, n) / n*0.5; 
	float w = 1.0-sqrt(xx-p.y+p.y*yy);

	return w;
	
}

float Krysler_352(vec2 p)
{
	p *=4.0;
	p.x = abs(p.x*0.5);
	p.y /= 4.0;
	float n = 2.0;
	float xx = pow(pow(p.x, n), n)*(p.y +1.0); 
	float yy = length(p)*p.x; 
	float w = 0.75-sqrt(xx-yy);

	return w;
	
}

float Krysler_353(vec2 p)
{
	p *= 2.0;
	float n = 8.0;
	float xx = pow(p.x, n)-abs(p.x)+unosc1; 
	float yy = pow(p.y, n)-abs(p.y); 
	float w = 1.0-sqrt(xx+yy);

	
	
	return w;
	
}

float Krysler_354(vec2 p)
{
	p *= 2.0;
	float n = 8.0;
	float xo = abs(log(p.x-1.0));
	float xx = pow(p.x, n)-(xo+osc1); 
	float yy = pow(p.y, n)-abs(p.y); 
	float w = 1.0-sqrt(xx+yy);

	
	
	return w;
	
}


float Krysler_355(vec2 p)
{
	p *= 1.5;
	float n = 8.0;
	float xo = log( abs(p.x)-1.0);
	float yo = pow(p.y, 4.0);
	float xx = pow(p.x, n)-(xo+0.25+osc1*0.5); 
	float yy = pow(p.y, n*4.0)*yo; 
	float w = 1.0-sqrt(xx+yy*xo) + abs(yo+xo);
	
	return w;
	
}

float Krysler_356(vec2 p)
{
	p *= 1.5;
	float yo = pow(p.y, 2.0);
	float xw = acos(cos(p.x*PI*2.0));
	xw = min(xw,1.0-length(p));
	xw += yo*yo;
	float g = smoothstep(0.0, 0.25, 1.0-abs(p.y));
	
	float xo = pow(p.x, 8.0);
	float yw = acos(cos(p.y*PI*2.0));
	yw = min(yw,length(p));
	yw += xo*xo;
	float w = 1.0-max(xw,yw);
	return w;
	
}

float Krysler_357(vec2 p)
{
	p *= 0.5;
	float ax = acos(cos(p.x*PI*16.0));
	float ay = acos(cos(p.y*PI*16.0));
	float yy = pow(p.y, 4.0)-abs(p.y);
	
	float w = 1.0-sqrt(ax-ay+yy*6.0);
	float len = length(p);
	float invlen = 1.0-len;
	return w*invlen*invlen*2.0;
	
}

float Krysler_358(vec2 p)
{
	p *= 0.5;
	float ax = acos(cos(p.x*PI*2.0));
	float ay = ax - acos(cos(p.y*PI*8.0));
	float k = pow(p.x, 4.0*abs(p.y))-abs(p.y);
	
	
	float w = 2.0-sqrt(ax+ay-k*4.0);
	float len = length(p);
	float invlen = 1.0-len;
	return pow(w*invlen, 2.0-abs(p.x)+0.5);
	
}


float Krysler_359(vec2 p)
{
	p /= 4.0;
	float x = abs(p.x*PI*8.0);
	float ax = min(acos(cos(x)), cos(x))+1.0;
	float y = abs(p.y*PI*8.0);
	float ay = min(acos(cos(y)), cos(y))+1.0;
	
	float a = 1.0-sqrt(ax*ay)*8.0;
	float b = 1.0-sqrt(ax-ay)*2.0;
	float len = length(p);
	float invlen = 1.0-len;
	
	return max(a,b);
	
}


void main( void ) {


	float shade = Krysler_359(pos); 
	vec3 clr = vec3(0.2, 0.66,0.9) * shade;
		
	
	gl_FragColor = vec4( clr, 1.0); 
				
}