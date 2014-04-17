
#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform float tick;



const float seed = 0.1;

const float max_red = 210.0 / 255.0;

float rand(vec2 co){
	// implementation found at: lumina.sourceforge.net/Tutorials/Noise.html
	co.x += seed;
	return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 434658.5453116487577816842168767168087910388737310);
}

float noise2f( in vec2 p )
{
	vec2 ip = vec2(floor(p));
	vec2 u = fract(p);
	// http://www.iquilezles.org/www/articles/morenoise/morenoise.htm
	u = u*u*(3.0-2.0*u);
	//u = u*u*u*((6.0*u-15.0)*u+10.0);
	
	float res = mix(
		mix(rand(ip),  rand(ip+vec2(1.0,0.0)),u.x),
		mix(rand(ip+vec2(0.0,1.0)),   rand(ip+vec2(1.0,1.0)),u.x),
		u.y)
	;
	return res*res;
	//return 2.0* (res-0.5);
}

float fbm(vec2 c) {
	float f = 0.0;
	float w = 1.0;
	for (int i = 0; i < 8; i++) {
		f+= w*noise2f(c);
		c*=2.0;
		w*=0.5;
	}
	return f;
}

float map(vec3 p)
{
    const int MAX_ITER = 10;
    const float BAILOUT=2.0;
    float Power = abs(sin(time/10.0)) * 20.0 + 5.;  

    vec3 v = p;
    vec3 c = v;

    float r=0.0;
    float d=1.0 * fbm(vec2(sin(time),cos(time)));
    for(int n=0; n<=MAX_ITER; ++n)
    {
        r = length(v)*1.1;
        if(r>BAILOUT) break;

        float theta = asin(v.z/r);
        float phi = atan(v.y, v.x);
        d = pow(r,Power-1.0)*Power*d+1.0;

        float zr = pow(r,Power);
        theta = theta*Power;
        phi = phi*Power;
        v = (vec3(sin(theta)*cos(phi), sin(phi)*sin(theta), cos(theta))*zr)-c;
    }
    return 0.4*log(r)*r/d;
}


void main( void )
{
    vec2 pos = (gl_FragCoord.xy*2.0 - resolution.xy) / resolution.y;
    vec3 camPos = vec3(cos(time*0.3), sin(time*0.3), 1.5);
    vec3 camTarget = vec3(0.0, 0.0, 0.0);

    vec3 camDir = normalize(camTarget-camPos);
    vec3 camUp  = normalize(vec3(0.0, 1.0, 0.0));
    vec3 camSide = cross(camDir, camUp);
    float focus = 1.8;

    vec3 rayDir = normalize(camSide*pos.x + camUp*pos.y + camDir*focus);
    vec3 ray = camPos;
    float m = 0.0;
    float d = 0.0, total_d = 0.0;
    const int MAX_MARCH = 64;
    const float MAX_DISTANCE = 5.0;
    for(int i=0; i<MAX_MARCH; ++i) {
        d = map(ray);
        total_d += d;
        ray += rayDir * d;
        m += 1.0;
        if(d<0.001) { break; }
        if(total_d>MAX_DISTANCE) { total_d=MAX_DISTANCE; break; }
    }

    float c = (total_d)*0.0001;
    vec4 result = vec4( 1.0-vec3(c, c, c) - vec3(0.025, 0.025, 0.02)*m*0.8, 1.0 );
    gl_FragColor = result;
}
