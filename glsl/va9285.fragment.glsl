// fuck that shit.

// https://www.shadertoy.com/view/lsf3RH

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main(void) 
{
	float delta = sin(time*1.0)*5.0 + cos(sin(time*1.3))*3.0;
	delta = time;
	
	vec2 position2 = gl_FragCoord.xy / resolution.xy - vec2(0.5, 0.5);
	position2 *= resolution.xy/(sin(delta*0.0)*5.0+290.0);

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
	
	gl_FragColor = vec4(fc, 1.0);
}