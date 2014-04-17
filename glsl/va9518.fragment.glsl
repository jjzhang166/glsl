// fuck that shit.

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float hash(float x)
{
	return fract(sin(x) * 43758.5453);
}

float noise(vec3 x)
{
	vec3 p = floor(x);
	vec3 f = fract(x);
	f = f*f*(3.0-2.0*f);
	float n = p.x + p.y * 57.0 + p.z*113.0;
	
	float a = hash(n);
	return a;
}

float manhattan(vec3 v)
{
	v = abs(v);
	return v.x + v.y + v.z;
}

float cheby(vec3 v)
{
	v = abs(v);
	return v.x > v.y
	? (v.x > v.z ? v.x : v.z)
	: (v.y > v.z ? v.y : v.z);
}

float someMetric(vec3 v)
{
	return  pow(v.x,2.0) + pow(v.y,2.0) + pow(v.z,2.0);
}

float vor(vec3 v)
{
	vec3 start = floor(v);
	
	float dist = 1.0;
	vec3 cand;
	
	for(int z = -2; z <= 2; z += 1)
	{
		for(int y = -2; y <= 2; y += 1)
		{
			for(int x = -2; x <= 2; x += 1)
			{
				vec3 t = start + vec3(x, y, z);
				vec3 p = t + noise(t);
			
				float d = someMetric(p - v);

				if(d < dist)
				{
					dist = d;
					cand = p;
				}
			}
		}
	}
	
	vec3 delta = cand - v;
	
	return someMetric(delta);
}

void main( void )
{	
	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	
	vec3 freq = vec3(0.005+sin(time*0.22)*0.003, 0.005+sin(time*0.22)*cos(time*0.22*5.0)*0.0005, 0.2);
	vec3 v = vec3(2. * gl_FragCoord.xy, time) * freq;
	v.x += sin(time*0.061)*10.0;
	v.y += sin(time*0.051)*10.0;
	
	float w =  max(0.1, min(1., vor(v)));
	float w0 = smoothstep(.9, .1, w) * (sin(time*0.33)*0.5+1.0);
	float w1 = smoothstep(.2, .9, vor(w+v-w0));

	vec4 c = vec4(w + w0*w1) * vec4(p.x * sin(time*0.12)*5.0, p.y + .8, .98, 1.);
	c.r *= mod(gl_FragCoord.y, 2.0);
	gl_FragColor = c;
}