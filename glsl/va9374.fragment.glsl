// fuck that shit.

// took a handful shaders and chained them together.

// "shader-track-mo", anyone? or simply "shadermo" ?

// (also: sorry for losing shader credits while toying around with this idea).

#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.141592653589793

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rect( vec2 p, vec2 b, float smooth )
{
	vec2 v = abs(p) - b;
  	float d = length(max(v,0.0));
	return 1.0-pow(d, smooth);
}

vec3 effectIn(float time) {
	float begin = 0.0;
	float end = 2.0/2.0;
	float offset = -1.5/2.0;
	if (time < begin) return vec3(0.0);
	if (time > end) return vec3(0.0);
	float delta = (time+offset)*2.0;
	
	vec2 unipos = (gl_FragCoord.xy / resolution);
	vec2 pos = unipos*2.0-1.0;
	pos.x *= resolution.x / resolution.y;

	float flash = sin(delta*1.0)*1.4-0.7;
	
	float d = rect(pos - vec2(0.0,0.0), vec2(0.50,0.25), 1.0);
	vec3 clr = vec3(0.99,0.6,0.2) *1.95*d + (0.925*flash)+(sin(delta)*1.0+1.0);

	clr.b *= mod(gl_FragCoord.y, 2.0)*5.0;
	return vec3( clr );
}

vec3 effectOut(float time) {	
	float begin = 2.0/2.0;
	float end = 2.0/2.0+3.0/2.0;
	float offset = -1.0/2.0;
	if (time < begin) return vec3(0.0);
	if (time > end) return vec3(0.0);
	float delta = (-time-offset+begin)*2.0;

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) - 0.5;

	float intensity = tan(sin(delta + position.x*0.5));
	vec3 color = intensity * vec3(1.0, 0.5, 0.8);
	
	float intensity2 = cos(position.y * 9.5);
	vec3 color2 = intensity2 * vec3(0.0, 0.5, 0.3);

	color.r *= mod(gl_FragCoord.y, 2.0);
	color2.b *= mod(gl_FragCoord.y, 2.0)*2.0;

	return vec3(color+color2)*(sin(delta)*3.0+4.0);
}

vec3 effectMain1(float delta) {
	vec2 p=.005*gl_FragCoord.xy;
	p.y += time*0.05;
	for(int i=1;i<30;i++)
	{
		vec2 newp=p;
		newp.x+=(sin(time*0.03)*1.0+10.0)/float(i)*sin(float(i)+0.2*p.y+time/40.0+0.3*float(i+200))+400./2.0;		
		newp.y+=(cos(time*0.01)*0.5+1.6)/float(i)*sin(float(i)*p.x+time/40.0+0.3*float(i+30))-1400./40.0+15.0;
		p=newp;
	}
	vec3 c =vec3(cos(p.y+p.x-PI*vec3(0,2,6)/(20.0+0.2*sin(time)))*0.3+0.35)/1.7;
	c.r *= mod(gl_FragCoord.y, 2.0);
	c.g *= sin(c.r*1.5);
	c.b += sin(c.r*1.5);
	return vec3(c*(gl_FragCoord.x/resolution.x*3.0));
}

float f(vec3 p) 
{ 
	p.z+=time*0.15+sin(time*0.6)*0.3;
	p.x+=sin(time*1.1)*0.2;
	p.y+=cos(time*0.4)*0.5;
	return length(.05*cos(9.*p.y*p.x)+cos(p)-.1*cos(9.*(p.z+.3*p.x-p.y)))-(sin(time*0.25)*0.05+0.05+1.0); 
}

vec3 effectMain2(float delta) {
	vec3 d=.5-gl_FragCoord.xyz/resolution.x,o=d;for(int i=0;i<9;i++)o+=f(o)*d*(sin(time*0.6)*0.3+0.3+1.0);
	vec3 c = vec3(abs(f(o-d+cos(time*0.1)*5.0)*vec3(.0,.0,.12)+f(o-vec3(sin(time*0.5)*0.1+5.4))*vec3(.25,.0012,.341))*(5.-o.z));
	c.r *= mod(gl_FragCoord.y, 2.0);
	return c;
}

vec3 effectMain3(float delta) {
	vec2 position2 = gl_FragCoord.xy / resolution.xy - vec2(0.5, 0.5);
	position2 *= resolution.xy/(sin(time*1.0)*5.0+90.0);

	float angle1 = time*0.5 + 0.00;
	float angle2 = time*0.5 + 0.04;
	float angle3 = time*0.5 + 0.08;
	vec2 d1 = vec2(cos(angle1), sin(angle1+sin(time)*0.2));
	vec2 d2 = vec2(cos(angle2), sin(angle2));
	vec2 d3 = vec2(cos(angle3), sin(angle3-sin(time)*0.2));

	float rr = cos(dot(position2, d1));
	float gg = cos(dot(position2, d2));
	float bb = cos(dot(position2, d3));

	vec2 position = gl_FragCoord.xy / resolution.xy - vec2(cos(time*0.2)*0.01+0.5, sin(time*0.4)*0.2+1.4);

	float r = length(position+sin(time*sin(time*0.005)*0.2)*1.2);
	float a = atan(position.y, position.x);
	float t = time + 1.0/(r+1.0);
	
	float light = 9.0*abs(0.05*(sin(t)+sin(time+a*25.0)));
	vec3 color = vec3(-sin(r*5.0-a-time+sin(r+t)), sin(r*3.0+a-time+sin(r+t)), cos(r+a*2.0+a+time)-sin(r+t));

	color.r *= sin(time)*0.5+0.5;
	color.g *= 0.5;
	color.b *= abs(cos(time*2.0)*0.5);
	
	vec3 fcolor = vec3(((color)+0.69) * light);
	fcolor.r *= 0.9;
	fcolor.g *= 0.3;
	fcolor.b *= 0.8;

	fcolor *= mod(gl_FragCoord.y, 2.0);
	
	fcolor *= vec3(rr, gg, bb)*2.0;
	return fcolor;
}

vec3 effectMain4(float delta) {
	delta = time;
	
	vec2 position2 = gl_FragCoord.xy / resolution.xy - vec2(0.5, 0.5);
	position2 *= resolution.xy/(sin(delta*2.0)*155.0+resolution.x+155.);

	float angle1 = delta*sin(delta*0.0001) + 0.00;
	float angle2 = delta*cos(delta*0.005)*0.0 + 0.04;
	float angle3 = delta*0.005*0.0 + 0.08;
	vec2 d1 = vec2(cos(angle1), sin(angle1+sin(delta)*0.5));
	vec2 d2 = vec2(cos(angle2), sin(angle2));
	vec2 d3 = vec2(cos(angle3), sin(angle3-sin(delta)*0.5));

	float rrr = cos(dot(position2, d1*2.0));
	float ggg = cos(dot(position2, d2));
	float bbb = cos(dot(position2, d3));

	vec2 p = -(sin(delta*1.0)*0.05+0.5) + gl_FragCoord.xy / resolution.xy;
	p.x *= resolution.x/resolution.y;
	
	float color = 3.0 - (3.*length(0.9*p));
	
	vec3 coord = vec3(atan(p.x,p.y)/6.2832+.5, length(p)*.4, .5);
	
	for(int i = 2; i <= 5; i++)
	{
		float power = pow(2.0, float(i));
		
		vec3 uv = coord + vec3(0.,-delta*.02, delta*.005);
		float res = power*16.0;
		
		const vec3 s = vec3(1e0, 1e2, 1e4);
		uv *= res;
		vec3 uv0 = floor(mod(uv, res))*s;
		vec3 uv1 = floor(mod(uv+vec3(1.), res))*s;
		
		vec3 f = fract(uv);
		f = f*f*(3.0-2.0*f);
		
		vec4 v = vec4(uv0.x+uv0.y+uv0.z, uv1.x+uv0.y+uv0.z,
			      uv0.x+uv1.y+uv0.z, uv1.x+uv1.y+uv0.z);
		
		vec4 r = fract(sin(v*1e-3)*1e5);
		float r0 = mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y);
		
		r = fract(sin((v + uv1.z - uv0.z)*1e-3)*1e5);
		float r1 = mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y);
		
		float snoise = mix(r0, r1, f.z)*2.0-1.0;
		
		color += (1.5 / power) * snoise;
	}
	
	float rr = color;
	float gg = pow(max(color,0.),2.)*0.4;
	float bb = pow(max(color,0.),3.)*0.15;
	
	vec3 fc = vec3(rr,gg,bb);
	fc.r *= mod(gl_FragCoord.y, 2.0);

	fc.r *= rrr*pow(rrr,-1.0);
	fc.g *= bbb*rrr;
	fc.b *= rrr*rrr;

	return fc;
	}
	
void main(  ) {
	float delta = time;
//	delta = time*0.2;
	
	const float interval = 5.0;
	const float effects = 4.0;
	float deltaIO = mod(delta, interval);
	float deltaM = mod(delta+4.00, interval*effects);
	float e = floor(deltaM/interval);
		
	vec3 c;
	c += clamp(effectIn(deltaIO), 0.0, 1.0);
	c += clamp(effectOut(deltaIO), 0.0, 1.0);
	
	if (e == 0.0) c += clamp(effectMain1(delta), 0.0, 1.0);
	if (e == 1.0) c += clamp(effectMain2(delta), 0.0, 1.0);
	if (e == 2.0) c += clamp(effectMain3(delta), 0.0, 1.0);
	if (e == 3.0) c += clamp(effectMain4(delta), 0.0, 1.0);

//	c *= 0.3;
	
	gl_FragColor = vec4(c, 1.0);
	}
