// fuck that shit.

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// a raymarching experiment by kabuto
//fork by tigrou ind (2013.01.22)


uniform sampler2D bb;


vec3 nrand3( vec2 co )
{
	vec3 a = fract( cos( co.x*8.3e-3 + co.y )*vec3(1.3e5, 4.7e5, 2.9e5) );
	vec3 b = fract( sin( co.x*0.3e-3 + co.y )*vec3(8.1e5, 1.0e5, 0.1e5) );
	vec3 c = mix(a, b, 0.5);
	return c;
}

vec3 paintOnIt() 
{
	vec2 D = vec2(1.0)/resolution;
	vec2 m  = mouse*resolution;
	vec2 uv = gl_FragCoord.xy / resolution;
	
	// sample 8-neighborhood
	vec4 dL = texture2D(bb, uv+vec2(-D.x, 0.0));
	vec4 dR = texture2D(bb, uv+vec2(D.x, 0.0));
	vec4 dU = texture2D(bb, uv+vec2(0.0, D.y));
	vec4 dD = texture2D(bb, uv+vec2(0.0, -D.y));
	vec4 dUL = texture2D(bb, uv+vec2(-D.x, D.y));
	vec4 dUR = texture2D(bb, uv+vec2(D.x, D.y));
	vec4 dLL = texture2D(bb, uv+vec2(-D.x, -D.y));
	vec4 dLR = texture2D(bb, uv+vec2(D.x, -D.y));
	
	// PLAY WITH ME:
	// ====================================
	vec4 s = (dL-dR+dU-dD+dUL+dUR+dLL*dLR);
	// ====================================
	vec4 val = vec4(nrand3(uv + 2.5)*(s.xyz), s.w / 3.0);
	
	val = (length(gl_FragCoord.xy - uv.xy) <= 0.0) ? vec4(nrand3(uv.xy), 0.2) : val;
	val /= val.w;
	
	if(time < 1.)
		val = vec4(.1);
	
	return val.xyz;

}

const int MAXITER = 25;

vec3 field(vec3 p) {
	p *= .1;
	float f = .1;
	for (int i = 0; i < 4; i++) {
		p = p.yzx*mat3(.6,.6,0,-.6,.6,0,0,0,1);
		p += vec3(.1,.456,.789)*float(0.1);
		p = abs(fract(p)-.5);
		p *= 2.0;
		f *= 2.001;
	}
	p *= p;
	return sqrt(p+p.yzx)/f-.035;
}

void main( void ) {
	float jit = 0.01;
	if (mod(time, 0.1) < 2.0) jit = 0.005;
	vec3 dir = normalize(vec3((gl_FragCoord.xy-resolution*.4)/resolution.x,1.));
	float a = sin(time)*0.01;
	vec3 pos = vec3(0.0,0.0,time*2.0);
	dir *= mat3(1,0,0,0,cos(a),-sin(a),0,sin(a),cos(a));
	dir *= mat3(cos(a),0,-sin(a),0,1,0,sin(a),0,cos(a));
	vec3 color = vec3(0);
	for (int i = 0; i < MAXITER; i++) {
		vec3 f2 = field(pos) *  paintOnIt();;
		float f = min(min(f2.x,f2.y),f2.z);
		
		pos += dir*f;
		color += float(MAXITER-i)/(f2+jit);
	}
	vec3 color3 = vec3(1.-1./(1.+color*(.09/float(MAXITER*MAXITER))));
	color3 *= paintOnIt();
	
	gl_FragColor = vec4(vec3(color3.r+color3.g+color3.b),1.);
}