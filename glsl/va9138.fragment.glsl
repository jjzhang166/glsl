
#ifdef GL_ES
precision mediump float;
#endif

/* checking what this is adding some color */

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 rgbFromHue(in float h) {
	
	const float K = 1.0/6.0;

	h = h - floor(h);
	float r = smoothstep( 2.0*K, 1.3*K, h) + smoothstep( 4.0*K, 5.0*K, h);
	float g = smoothstep( 0.0*K, 1.0*K, h) - smoothstep( 3.0*K, 4.0*K, h);
	float b = smoothstep( 2.0*K, 3.0*K, h) - smoothstep( 5.0*K, 6.0*K, h);
	return vec3(r,g,b);
}

float map(const in vec3 p)
{
    const int MAX_ITER = 12;
    const float BAILOUT= 1.2;
    float Power = 6.0;

    vec3 v = p;

    float r=0.0;
    float d=1.0;
	
    for(int n=0; n<=MAX_ITER; ++n)
    {
        r = length(v);
        if(r>BAILOUT) break;

        float theta = time*0.04 + 1.0*acos(v.z/r);
        float phi   = sin(time*0.61) - atan(v.y-0.5, v.x);
	    
        d = pow(r-0.1,Power-2.0)*Power*d + 1.1;

        float zr = pow(r,Power);
        theta = theta*Power;
        phi = phi*Power;
        v = (vec3(sin(theta)*cos(phi), sin(phi)*sin(theta), cos(theta))*zr)+p;
    }

    return 0.5*log(r)*r/d;
}


void main( void )
{
    vec2 pos = (gl_FragCoord.xy*2.0 - resolution.xy) / resolution.y;
    vec3 camPos = vec3(cos(time*0.1)*3.0, 1.5, sin(time*0.1)*3.0);
    vec3 camTarget = vec3(0.0, 0.0, 0.0);
	

    vec3 camDir = normalize(camTarget-camPos);
    vec3 camUp  = normalize(vec3(0.0, 1.0, 0.0));
    vec3 camSide = cross(camDir, camUp);
    float focus = 2.5;

    vec3 rayDir = normalize(camSide*pos.x + camUp*pos.y + camDir*focus);
    vec3 ray = camPos;
    float m = 0.0;
    float d = 0.0, total_d = 0.0;
    const int MAX_MARCH = 40;
    const float MAX_MARCH_INV_F = 1.0/40.0;
    const float MAX_DISTANCE = 310.0;
    const float MAX_DISTANCE_INV_F = 2.0/MAX_DISTANCE;
	
    for(int i=0; i<MAX_MARCH; ++i) {
        d = map(ray);
        total_d += d;
        ray += rayDir * d;
        m += MAX_MARCH_INV_F;
        if(d < 0.0015) { break; }
        if(total_d > MAX_DISTANCE) { break; }
    }

    vec3 color;
	
    color = rgbFromHue(total_d)*(1.0-m)*(1.0-(total_d * MAX_DISTANCE_INV_F));

	
    gl_FragColor = vec4(color, 1.0);
	
}
