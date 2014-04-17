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

float shape341b_aktenzeichen_n12_strich_19(vec2 p)
{
	p.y *= 8.0;
	float n = 16.0;
	float xx = pow(pow(p.x, n), n); 
	float yy = log(pow(p.y, n)) / n*0.5; 
	float w = 1.0-sqrt(xx-yy);

	return w;
	
}


float Krysler_004(vec2 p)
{
	float a= shape341b_aktenzeichen_n12_strich_19(p);
	return max(a, 0.0);
	
}

void main( void ) {


	float shade = Krysler_004(pos); 
	vec3 clr_a = vec3(0.2, 0.66,0.9) * shade;
	vec3 clr_b = vec3(0.9, 0.66, 0.2) * shade*0.25;
	float m = 0.75-pos.y;
	vec3 clr = mix(clr_a, clr_b, m);
	
	gl_FragColor.a = 1.0;
	gl_FragColor.rgb = clr; 
				
}