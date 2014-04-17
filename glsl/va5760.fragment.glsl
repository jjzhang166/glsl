#ifdef GL_ES
precision mediump float;
#endif
// with greetings text  (need to do an array with greetings) ;-)

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float AMDLogo(vec2 p) {
	
	float y = floor((0.1-p.y)*60.);// moving y
	if(y < 0. || y > 4.) return 0.; // Bit count Y
	float x = floor((0.3-p.x)*60.)-2.;//moving x
	if(x < 0. || x > 14.) return 0.; // Bit count X
		
	float v = 3.0;
	// read the BIN upside down and you got the letters...
	v = mix(v, 18990.0, step(y, 7.5)); //100101000101110
	v = mix(v, 18985.0, step(y, 3.5)); //100101000101001
	v = mix(v, 31401.0, step(y, 2.7)); //111101010101001 
	v = mix(v, 19305.0, step(y, 1.5)); //100101101101001
	v = mix(v, 12846.0, step(y, 0.0)); //011001000101110
	
	return floor(mod(v/pow(2.,x), 2.0));
}

float AMDLogo2(vec2 p) {
	
	float y = floor((1.0-p.y)*60.);
	if(y < 0. || y > 4.) return 0.; // Bit count Y

	float x = floor((1.0-p.x)*60.)-2.;
	if(x < 0. || x > 20.) return 0.; // Bit count X
		
	float v = 0.0;
	// read the BIN upside down and you got the letters...
	v = mix(v, 18990.0, step(y, 7.5)); //100101000101110
	v = mix(v, 18985.0, step(y, 3.5)); //100101000101001
	v = mix(v, 31401.0, step(y, 2.7)); //111101010101001 
	v = mix(v, 19305.0, step(y, 1.5)); //100101101101001
	v = mix(v, 12846.0, step(y, 0.0)); //011001000101110
	
	return floor(mod(v/pow(2.,x), 2.0));
}


float hash(float n) { return fract(pow(sin(n), 1.1)*1e6); }

float snoise(vec3 p)
{
	const vec3 d = vec3(1.,30.,30.*30.);

	p *= 2.;
	vec3 f = fract(p);
	float n = dot(floor(p),d);
	f = f*f*(3.0-2.0*f);
	return mix(mix(mix(hash(n), hash(n+d.x),f.x),
		       mix(hash(n+d.y), hash(n+d.x+d.y),f.x), f.y),
		   mix(mix(hash(n+d.z), hash(n+d.x+d.z),f.x),
		       mix(hash(n+d.y+d.z), hash(n+d.x+d.y+d.z),f.x), f.y), f.z)*2.-1.;
}

vec3 helper(float d, float r, vec2 p, float s, float f) {
    float a = acos(d / r) - 3.141592 / 2.0;
    vec2 tp = vec2(a * p.x / d, a * p.y / d) * s;
    tp += vec2(snoise(vec3(tp, time)), snoise(vec3(tp, time+10.3))) * 0.4;
    tp += vec2(time * 2.0, 0.0);
    float n = snoise(vec3(tp, time*f + s + f));
    return vec3(0.5+n*1.7, n*1.5+0.12, n*1.2);
}

void main( void ) {
float z = AMDLogo(gl_FragCoord.xy / resolution.xy);
float x = AMDLogo2(gl_FragCoord.xy / resolution.xy);

	vec2 p = gl_FragCoord.xy / resolution.y * 2.0 - vec2(resolution.x / resolution.y, 1.0);
  float r = 1.0;
  float d = length(p);
  vec3 c = helper(d, r, p, 4.0, 1.2)  + helper(d, r, p, 1.0, 1.0) + helper(d, r, p, 1.0, 0.1);
  gl_FragColor = vec4(x+z+c*(1.-d), 1.0);
}
