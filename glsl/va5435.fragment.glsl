#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
uniform sampler2D backbuffer;

//////////////////////////////////////////////////////////////
// http://www.gamedev.net/topic/502913-fast-computed-noise/
// replaced costly cos with z^2. fullreset
vec4 random4 (const vec4 x) {
    vec4 z = mod(mod(x, vec4(5612.0)), vec4(3.1415927 * 2.0));
    return fract ((z*z) * vec4(56812.5453));
}
const float A = 1.0;
const float B = 57.0;
const float C = 113.0;
const vec3 ABC = vec3(A, B, C);
const vec4 A3 = vec4(0, B, C, C+B);
const vec4 A4 = vec4(A, A+B, C+A, C+A+B);
float cnoise4 (const in vec3 x) {
    vec3 fx = fract(x);
    vec3 ix = floor(x);
    vec3 wx = fx*fx*(3.0-2.0*fx);
    float nn = dot(ix, ABC);

    vec4 N1 = nn + A3;
    vec4 N2 = nn + A4;
    vec4 R1 = random4(N1);
    vec4 R2 = random4(N2);
    vec4 R = mix(R1, R2, wx.x);
    float re = mix(mix(R.x, R.y, wx.y), mix(R.z, R.w, wx.y), wx.z);

    return 1.0 - 2.0 * re;
}


float fbm(vec3 p) {
 float N = 0.0;
  float D = 0.0;
  int i=0;
  float R = 0.0;
  D += (R = 1.0/pow(2.0,float(i+1))); N = cnoise4(p*pow(2.0,float(i)))*R + N; i+=1;
  D += (R = 1.0/pow(2.0,float(i+1))); N = cnoise4(p*pow(2.0,float(i)))*R + N; i+=1;
  D += (R = 1.0/pow(2.0,float(i+1))); N = cnoise4(p*pow(2.0,float(i)))*R + N; i+=1;
  D += (R = 1.0/pow(2.0,float(i+1))); N = cnoise4(p*pow(2.0,float(i)))*R + N; i+=1;
  return N/D;
}

float surface3 ( vec3 coord ) {
	
	float frequency = 4.0;
	float n = 0.0;	
		
	n += 0.5	         * abs( cnoise4(coord * frequency ) );
	n += 0.25	 * abs( cnoise4(coord * frequency * 2.0 ) );
	n += 0.125	 * abs( cnoise4(coord * frequency * 4.0 ) );
	
	n = n/0.975;
        return n*n*(3.0-2.0*n);
}
	
void main( void ) {
	
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	
	float n = surface3(vec3(uv, time * 0.1))*4.;
		
	gl_FragColor = vec4(n, n, n, 1.0);
        vec2 d = 4.0/resolution;
	float dx = texture2D(backbuffer, uv + vec2(-0.5,0.)*d).x - texture2D(backbuffer, uv + vec2(0.5,0.)*d).x ;
	float dy = texture2D(backbuffer, uv + vec2(0.,-0.5)*d).x - texture2D(backbuffer, uv + vec2(0.,0.5)*d).x ;
	d = vec2(dx,dy)*resolution;
	gl_FragColor.b = pow(clamp(1.-1.5*length(uv  - mouse + d),0.,1.),4.0);
	gl_FragColor.g = gl_FragColor.b*0.5 + gl_FragColor.r*0.25;
	gl_FragColor = gl_FragColor*0.25 + texture2D(backbuffer,uv)*0.75;
}
