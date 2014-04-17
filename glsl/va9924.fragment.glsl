#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

const float pi = 3.14159;

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

float quad(vec3 v)
{
	return pow(pow(v.x,4.0) + pow(v.y,4.0) + pow(v.z,4.0), 0.25);
}

float cheby(vec3 v)
{
	v = abs(v);
	return v.x > v.y
	? (v.x > v.z ? v.x : v.z)
	: (v.y > v.z ? v.y : v.z);
}

float vor(vec3 v)
{
	vec3 start = floor(v);
	
	float dist = 3.0;
	vec3 cand;
	
	for(int z = -2; z <= 2; z += 1)
	{
		for(int y = -2; y <= 2; y += 1)
		{
			for(int x = -2; x <= 2; x += 1)
			{
				vec3 t = start + vec3(x, y, z);
				vec3 p = t + noise(t);

				float d = length(p - v);

				if(d < dist)
				{
					dist = d;
					cand = p;
				}
			}
		}
	}
	
	vec3 delta = cand - v;
	
	return length(delta);
}

float voronoi( vec3 p)
{	
	vec3 v = vec3(2. * p );
	
	float w = vor(v);
	
	return w;
}


vec2 rand_mod(vec2 pos, float seed)
{
	return fract( pow(pos+2.0+fract(seed), pos.yx+2.0 )*22222.0 );
}

vec2 rand(vec2 pos, float seed)
{
	return rand_mod( rand_mod(rand_mod(pos, seed), seed), seed);
}

void main( void )
{
	const int U_COLOR = 2;
	const int V_COLOR = 0;
	const float a = 0.02;
	const float b = 0.2;
	const float c = -65.0;
	const float d = 8.0;
	const float dt = 0.005;
	const float scale = 40.0;
	const int connection = 4;
	
	vec2 position = gl_FragCoord.xy / resolution.xy;
	
	vec2 s[connection];
	s[0] = vec2(0,1);
	s[1] = vec2(1,0);
	s[2] = vec2(0,-1);
	s[3] = vec2(-1,0);
	
	float vor;	
	//if(mouse.x <= 0.1){
		float vscale = 8.;
		
		vor = voronoi(vec3(position * vscale, 1.)); //a topology upon which they may ponder
		
	
		//vec4 vmod = texture2D(backbuffer, gl_FragCoord.xy / resolution.xy );
		//vor = length(vmod) * voronoi(vec3(position * vscale, 1.));
		
		vor = pow(vor, 1.5);
		vor = 1.-vor;
		vor *= length(vec2(.5,.5)-position) * .5;
		//vor += clamp(pow(1.-length(position-mouse), 32.), 0., 1.);
		vor = clamp(vor, 0., 1.);
		s[0] *= vor;
		s[1] *= vor;
		s[2] *= vor;
	//}
	
	float i =  10.0 * rand(position, time)[0];
	float v = scale * texture2D(backbuffer, gl_FragCoord.xy / resolution.xy )[V_COLOR];
	float u = scale * texture2D(backbuffer, gl_FragCoord.xy / resolution.xy )[U_COLOR];


	if( v>=30.0 ) {
		v = c;
		u = u + d;
	}

	//orly? //sphinx
	for(int j=0;j<connection; j++) {
		vec2 pos = (gl_FragCoord.xy+s[j]) / resolution.xy;
		if( rand(pos, float(j)/10.0 )[0] >=0.2 ) { 
			//Excitatory neurons
			i = i + 0.5 *  scale * texture2D(backbuffer, pos)[V_COLOR];
		}else{
			//Inhivitory neurons
			i = i - 1.0 *  scale * texture2D(backbuffer, pos)[V_COLOR];
		}
	}
	
	v = v + dt * 0.5*(0.04*v*v+5.0*v+140.0-u+i);
	v = v + dt * 0.5*(0.04*v*v+5.0*v+140.0-u+i);
	u = u+ dt * a * (b * v - u);
	vec4 color = vec4(0.0,0.0,0.0,1.0);
	color[U_COLOR] = u / scale;
	color[V_COLOR] = v / scale;
	
	
	if(mouse.y <= 0.1){
		color = vec4(0.);	
	}
	
	if(mouse.x <= 0.1){
		color = vec4(vor);	
	}
	
	gl_FragColor = color;
}